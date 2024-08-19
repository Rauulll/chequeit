defmodule ChequeitWeb.UserSessionController do
  use ChequeitWeb, :controller

  def index(conn, _params) do
    user = %{email: nil}
    render(conn, :index, user: user , layout: false)
  end

end
