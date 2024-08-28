defmodule Novy.Wakfu.WakfuItemEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wakfu_items" do
    field :title_fr, :string
    field :title_en, :string
    field :title_es, :string
    field :title_pt, :string
    field :description_fr, :string
    field :description_en, :string
    field :description_es, :string
    field :description_pt, :string

    field :level, :integer
    field :rarity, :integer
    belongs_to :type, Novy.Wakfu.WakfuItemTypeEntity

    field :gfxId, :integer
    field :femaleGfxId, :integer

    timestamps()
  end

  @doc false
  def changeset(wakfu_item, attrs) do
    wakfu_item
    |> cast(attrs, [:title_fr, :title_en, :title_es, :title_pt, :description_fr, :description_en, :description_es, :description_pt])
    |> validate_required([:title_fr, :description_fr])
  end
end
