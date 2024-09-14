defmodule Chequeit.Banks.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "banks" do
    field :account_id, :binary_id
    field :bank_id, :binary_id
    field :access_token, :string
    field :funding_source_url, :binary_id
    field :shareable_id, :binary_id

    belongs_to (:user), Chequeit.Account.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [])
    |> validate_required([])
  end
end
