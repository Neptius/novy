defmodule Novy.Wakfu.WakfuItemTypeEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wakfu_item_types" do
    field :title_fr, :string
    field :title_en, :string
    field :title_es, :string
    field :title_pt, :string

    field :equipment_positions, {:array, :string}, default: []

    belongs_to :parent, WakfuItemTypeEntity
    has_many :sub_types, WakfuItemTypeEntity

    timestamps()
  end

  @doc false
  def changeset(wakfu_item, attrs) do
    wakfu_item
    |> cast(attrs, [:title_fr, :title_en, :title_es, :title_pt])
    |> validate_required([:title_fr])
  end
end
