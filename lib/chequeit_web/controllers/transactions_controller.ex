defmodule ChequeitWeb.TransactionsController do
  use ChequeitWeb, :controller

  def transactions(conn, _params) do
    render(conn, :transactions)
  end
end
