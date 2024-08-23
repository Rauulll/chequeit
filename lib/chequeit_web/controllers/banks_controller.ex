defmodule ChequeitWeb.BanksController do
  use ChequeitWeb, :controller

  def banks(conn, _params) do
    IO.puts("=======")
    IO.inspect(conn)
    IO.puts("=======")
    render(conn, :banks)
  end
end
