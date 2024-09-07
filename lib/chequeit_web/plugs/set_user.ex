defmodule ChequeitWeb.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Ecto
  alias Chequeit.Account

  def init(_opt) do
  end

  def call(conn, _opt) do
    user_token = get_session(conn, :user_token, nil)

    cond do
      user = user_token &&  Account.get_user_by_session_token(user_token)->
        user_map = Map.from_struct(user)
        IO.inspect(user_map)
        conn
        |> assign(:user, user_map)
      true ->
        conn
        |> redirect(to: "/auth/sign-in")
    end
  end
end
