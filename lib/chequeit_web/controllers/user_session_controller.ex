defmodule ChequeitWeb.UserSessionController do
  use ChequeitWeb, :controller

  alias ChequeitWeb.UserAuth

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    uuid = Application.get_env(:chequeit, ChequeitWeb.Endpoint, :fixed_namespace_uuid) |> Keyword.get(:fixed_namespace_uuid)

    userId = UUID.uuid5(uuid, email)

    headers = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_project_id) |> Keyword.get(:appwrite_project_id)}",
      "X-Appwrite-Key": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_secret) |> Keyword.get(:appwrite_secret)}"
    ]

    url = "https://cloud.appwrite.io/v1/users/#{userId}"

    # response = HTTPoison.get!(url, headers)

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        user = Jason.decode!(body)
        %{"password" => stored_hash_password} = user
        case Argon2.verify_pass(password, stored_hash_password) do
          true ->
            conn
            |> put_flash(:info, "Welcome!")
            |> UserAuth.sign_in_user(user)
          false ->
            conn
            |> put_flash(:error, "Invalid email or password")
            |> redirect(to: ~p"/auth/sign-in")
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        conn
          |> put_flash(:error, "Not Found :(")
          |> redirect(to: ~p"/auth/sign-in")
      {:error, %HTTPoison.Error{reason: _reason}} ->
        conn
          |> put_flash(:error, "An error occurred during signing in")
          |> redirect(to: ~p"/auth/sign-in")
    end
  end

  def delete(conn, _params) do
    UserAuth.sign_out(conn)
  end
end
