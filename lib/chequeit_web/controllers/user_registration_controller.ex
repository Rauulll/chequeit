defmodule ChequeitWeb.UserRegistrationController do
  use ChequeitWeb, :controller

  alias Chequeit.Accounts
  alias Chequeit.Accounts.User

  def index(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :index, changeset: changeset, layout: false)
  end

  def create(_conn, %{"user" => _user_params}) do
    #handle POST Functionalities
  end
end
