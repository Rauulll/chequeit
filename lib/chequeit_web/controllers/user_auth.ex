defmodule ChequeitWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias ChequeitWeb.Api.ApiController

  @doc false
  def create_user_session(conn, %{"$id" => id}, user) do
    header = [
      "Host": "cloud.appwrite.io",
      "Content-Type": "application/json",
      "X-Appwrite-Response-Format": "1.5.0",
      "X-Appwrite-Project": "#{ApiController.appwrite_project_id}",
      "X-Appwrite-Key": "#{ApiController.appwrite_key}"
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

  def sign_out(conn) do
    appwrite_session = get_session(conn, :appwrite_session)
    user = get_session(conn, :user)
    delete_appwrite_session(appwrite_session, user)

    conn
    |> clear_session()
    |> redirect(to: "/auth/sign-in")
  end

  defp delete_appwrite_session(appwrite_session, user) do
    user_id = user.id
    HTTPoison.delete("https://cloud.appwrite.io/v1/users/#{user_id}/sessions/#{appwrite_session}")
  end
end
