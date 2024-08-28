defmodule Novy.Repo.Migrations.CreateWakfuItemTypes do
  use Ecto.Migration

  def change do
    create table(:wakfu_item_types) do
      add :title_fr, :string
      add :title_en, :string
      add :title_es, :string
      add :title_pt, :string

      add :equipment_positions, {:array, :string}, default: []

      add :parent_id, references(:wakfu_item_types, on_delete: :nilify_all)

      timestamps()
    end
  end
end
