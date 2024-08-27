defmodule ChequeitWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  @doc false
  def create_user_session(conn, %{"$id" => id}, user) do
    header = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_project_id) |> Keyword.get(:appwrite_project_id)}",
      "X-Appwrite-Key": "#{Application.get_env(:chequeit, ChequeitWeb.Endpoint, :appwrite_secret) |> Keyword.get(:appwrite_secret)}"
    ]

    case HTTPoison.post("https://cloud.appwrite.io/v1/users/#{id}/sessions", [], header) do
      {:ok, %HTTPoison.Response{body: body}} ->
        response_body = Jason.decode!(body)
        %{"secret" => secret} =response_body
        conn
        |> put_session(:user, user)
        |> put_session(:appwrite_session, secret)
      {:error, %HTTPoison.Error{reason: reason}} ->
        conn
        |> put_flash(:error, reason)
        |> halt()
      _ ->
        conn
        |> put_flash(:error, "Oops!, sth is wrong!")
    end
  end

  @doc false
  def sign_in_user(conn, user) do
    %{"email" => email, "name" => name, "$id" => id} = user
    new_user_map = %{email: email, name: name, id: id}


    conn
    |> clear_session()
    |> configure_session(renew: true)
    |> create_user_session(user, new_user_map)
    |> redirect(to: "/")
  end
end
