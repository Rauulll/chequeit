defmodule ChequeitWeb.BanksController do
  use ChequeitWeb, :controller

  def banks(conn, _params) do
    render(conn, :banks)
  end
end
