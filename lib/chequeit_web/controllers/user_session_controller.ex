defmodule ChequeitWeb.UserSessionController do
  use ChequeitWeb, :controller

  alias Chequeit.Account
  alias ChequeitWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil, layout: false)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Account.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid email or password", layout: false)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
