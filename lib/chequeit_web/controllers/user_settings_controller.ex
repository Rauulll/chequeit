defmodule ChequeitWeb.UserSettingsController do
  use ChequeitWeb, :controller

  alias Chequeit.Account
  alias ChequeitWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, :edit, layout: false)
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Account.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Account.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/auth/settings/confirm_email/#{&1}")
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: ~p"/auth/settings")

      {:error, changeset} ->
        render(conn, :edit, email_changeset: changeset, layout: false)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Account.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, ~p"/auth/settings")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, :edit, password_changeset: changeset, layout: false)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Account.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: ~p"/auth/settings")

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: ~p"/auth/settings")
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Account.change_user_email(user))
    |> assign(:password_changeset, Account.change_user_password(user))
  end
end
