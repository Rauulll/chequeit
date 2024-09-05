defmodule ChequeitWeb.UserRegistrationController do
  use ChequeitWeb, :controller

  alias Chequeit.Accounts
  alias Chequeit.Accounts.User
  alias ChequeitWeb.UserAuth

  def index(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :index, changeset: changeset, layout: false)
  end

  def create(conn, params) do
    %{"user" => user} = params

    changeset = Accounts.register_user(user)
    appwrite_create_user(conn, changeset)
  end

  defp appwrite_create_user(conn, %Ecto.Changeset{} = changeset) do
    #generate unique user_id
    uuid = Application.get_env(:chequeit, ChequeitWeb.Endpoint, :fixed_namespace_uuid) |> Keyword.get(:fixed_namespace_uuid)

    userId = UUID.uuid5(uuid, "#{changeset.changes[:email]}")

    new_changeset = Map.update!(changeset.changes, :password, fn existing_password ->
      Argon2.hash_pwd_salt(existing_password)
    end )

    user_params =
      new_changeset
      |> Map.put_new(:userId, userId)
      |> Map.put_new(:name, "#{changeset.changes[:first_name]} #{changeset.changes[:last_name]}")

    body = Jason.encode!(user_params)

    header = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_project_id) |> Keyword.get(:appwrite_project_id)}",
      "X-Appwrite-Key": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_secret) |> Keyword.get(:appwrite_secret)}"
    ]

    case HTTPoison.post("https://cloud.appwrite.io/v1/users/argon2", body, header) do
      {:ok, %HTTPoison.Response{body: body}}->
        response = Jason.decode!(body)
        %{"email" => email, "name" => name, "$id" => id} = response
        user = %{email: email, name: name, id: id}

        conn
        |> UserAuth.create_user_session(response, user)
        |> put_flash(:info, "Account created successfully")
        |> redirect(to: "/auth/link-bank")

      {:error, %HTTPoison.Error{reason: _reason}} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "An error occurred while trying ti sign up")

      _->
        conn
          |> put_status(500)  # Set internal server error status code
          |> put_flash(:info, "Unexpected error during user creation")
     end
  end
end
