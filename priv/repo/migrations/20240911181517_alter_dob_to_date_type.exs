defmodule Chequeit.Repo.Migrations.AlterDobToDateType do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :date_of_birth, :date
    end
  end
end
