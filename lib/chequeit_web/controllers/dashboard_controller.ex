defmodule ChequeitWeb.DashboardController do
  use ChequeitWeb, :controller

  def dashboard(conn, _params) do
    user =  get_session(conn, :user)
    render(conn, :dashboard, user: user)
  end
end
