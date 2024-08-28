defmodule Novy.Repo.Migrations.CreateWakfuItems do
  use Ecto.Migration

  def change do
    create table(:wakfu_items) do
      add :title_fr, :string
      add :title_en, :string
      add :title_es, :string
      add :title_pt, :string
      add :description_fr, :text
      add :description_en, :text
      add :description_es, :text
      add :description_pt, :text

      add :level, :integer
      add :rarity, :integer
      add :type_id, references(:wakfu_item_types, on_delete: :nilify_all)

      add :gfxId, :integer
      add :femaleGfxId, :integer

      timestamps()
    end
  end
end
