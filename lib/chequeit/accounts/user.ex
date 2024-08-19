defmodule Chequeit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :address1, :string
    field :city, :string
    field :postal_code, :string
    field :date_of_birth, :string
    field :email, :string
    field :password, :string

  end

  @doc false
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:first_name, :last_name, :address1, :city, :postal_code, :date_of_birth, :email, :password])
    |> validate_required([:first_name, :last_name, :address1, :city, :postal_code, :date_of_birth, :email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, _opts) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  defp validate_password(changeset, _opts) do
    changeset
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
  end
end
