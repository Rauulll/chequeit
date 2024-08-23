defmodule Chequeit.Accounts do
  alias Chequeit.Accounts.User

  @doc """
  Validation of user input
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end
end
