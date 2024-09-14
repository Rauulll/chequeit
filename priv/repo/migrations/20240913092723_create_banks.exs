defmodule Chequeit.Repo.Migrations.CreateBanks do
  use Ecto.Migration

  def change do
    create table(:banks, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), null: false
      add :account_id, :uuid
      add :bank_id, :uuid
      add :access_token, :string
      add :funding_source_url, :uuid
      add :shareable_id, :uuid
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      timestamps(type: :utc_datetime)
    end
  end
end
