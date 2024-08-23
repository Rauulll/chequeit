defmodule ChequeitWeb.UserRegistrationController do
  use ChequeitWeb, :controller

  alias Chequeit.Accounts
  alias Chequeit.Accounts.User

  def index(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :index, changeset: changeset, layout: false)
  end

  def create(conn, params) do
    %{"user" => user} = params

    changeset = Accounts.register_user(user)
    appwrite_create_user(changeset, conn)
  end

  def appwrite_create_user(%Ecto.Changeset{} = changeset, conn) do
    user_params = changeset.changes

    #generate unique user_id
    userId = UUID.uuid5(UUID.uuid4(), "#{changeset.changes[:email]}")

    new_user_params =
      user_params
      |> Map.put_new(:userId, userId)
      |> Map.put_new(:name, "#{changeset.changes[:first_name]} #{changeset.changes[:last_name]}")

    body = Jason.encode!(new_user_params)

    headers = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "66c447850018d37b386c",
      "X-Appwrite-Key": "f30f34d6f35853f9966205e8b628538dbfe6bddd8c72686fa69897b1ac14ec60f189c45722bc23752d734634a7229affd24b387a239540332d76ac2df8ae31dab56cbab0d9589f3f60b07fa441e10114cf600ddf66a8795c674c7cf411acc7f792f6ca492ac0d20628edd26c1c999b0d96428a9a3e8b88bef7597f86333cf760"
    ]

    case HTTPoison.post("https://cloud.appwrite.io/v1/users", body, headers) do
      {:ok, %HTTPoison.Response{body: body}}->
        response = Jason.decode!(body)
        create_user_session(conn, response)
      {:error, %HTTPoison.Error{reason: reason}} ->
        error = Jason.decode!(reason)
        conn
        |> put_status(400)
        |> put_flash(:error, :reason)
        |> render(:index, error: error)
      _->
        IO.puts("Unexpected error during user creation:")
        conn
          |> put_status(500)  # Set internal server error status code
          |> halt()
    end
  end

  def create_user_session(conn, %{"$id" => id}) do
    IO.inspect(id)
    headers = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "66c447850018d37b386c",
      "X-Appwrite-Key": "f30f34d6f35853f9966205e8b628538dbfe6bddd8c72686fa69897b1ac14ec60f189c45722bc23752d734634a7229affd24b387a239540332d76ac2df8ae31dab56cbab0d9589f3f60b07fa441e10114cf600ddf66a8795c674c7cf411acc7f792f6ca492ac0d20628edd26c1c999b0d96428a9a3e8b88bef7597f86333cf760"
    ]


    url = "https://cloud.appwrite.io/v1/users/#{id}/sessions"

    case HTTPoison.post(url, [], headers) do
      {:ok, %HTTPoison.Response{body: body}} ->
        response_body = Jason.decode!(body)
        %{"secret" => secret} = response_body
        conn
         |> put_session(:appwrite_session, secret)
         |> redirect(to: "/")
      {:error, %HTTPoison.Error{reason: reason}} ->
        conn
        |> put_flash(:error, reason)
        |> halt()
      _ ->
        IO.puts("an error ocurred while creating session")
    end
  end
end
