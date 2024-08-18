defmodule ChequeitWeb.TransferController do
  use ChequeitWeb, :controller

  def transfer(conn, _params) do
    render(conn, :transfer)
  end
end
