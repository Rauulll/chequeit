defmodule ChequeitWeb.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  def init(_opt) do
  end

  def call(conn, _opt) do
    user = get_session(conn, :appwrite_session, nil)

    cond do
      user == nil ->
        conn
        |> put_flash(:error, "Oops, You must be Signed in!")
        |> redirect(to: "/auth/sign-in")
      true ->
        conn
    end
  end
end
