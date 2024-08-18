defmodule ChequeitWeb.AuthController do
  use ChequeitWeb, :controller

  def sign_in(conn, _params) do
    render(conn, :signin)
  end
end
