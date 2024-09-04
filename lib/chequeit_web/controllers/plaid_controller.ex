defmodule ChequeitWeb.PlaidController do
  use ChequeitWeb, :controller

  def index(conn, _params) do
    render(conn, layout: false)
  end
end
