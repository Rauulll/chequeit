defmodule ChequeitWeb.DashboardController do
  use ChequeitWeb, :controller

  def dashboard(conn, _params) do
    render(conn, :dashboard)
  end
end
