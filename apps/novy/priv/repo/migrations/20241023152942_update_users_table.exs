defmodule Novy.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :pseudo, :string
      add :discord_id, :string
    end
  end
end
