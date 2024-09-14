defmodule Chequeit.Repo.Migrations.AddUserDetails do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :ssn, :integer
      add :state, :string
    end
  end
end
