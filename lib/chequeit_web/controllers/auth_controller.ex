defmodule ChequeitWeb.AuthController do
  use ChequeitWeb, :controller

  def sign_in(conn, _params) do
    render(conn, :signin, layout: false)
  end

  def sign_up(conn, _params) do
    render(conn, :signup, layout: false)
  end
end
