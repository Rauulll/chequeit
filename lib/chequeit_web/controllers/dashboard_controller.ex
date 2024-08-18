defmodule ChequeitWeb.DashboardController do
  use ChequeitWeb, :controller

  def dashboard(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :dashboard)
  end
end
