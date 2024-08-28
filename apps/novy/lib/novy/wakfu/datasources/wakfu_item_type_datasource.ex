defmodule Novy.Wakfu.WakfuItemTypeDatasource do
  @moduledoc """
  The WakfuDatas context.
  """

  import Ecto.Query, warn: false
  alias Novy.Repo

  alias Novy.Wakfu.WakfuItemTypeEntity, as: WakfuItemType

  @doc """
  Returns the list of wakfu_item_types.

  ## Examples

      iex> list_wakfu_item_types()
      [%WakfuItemType{}, ...]

  """
  def list_wakfu_item_types do
    Repo.all(WakfuItemType)
  end

  @doc """
  Gets a single wakfu_item_type.

  Raises `Ecto.NoResultsError` if the Wakfu item_type does not exist.

  ## Examples

      iex> get_wakfu_item_type!(123)
      %WakfuItemType{}

      iex> get_wakfu_item_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wakfu_item_type!(id), do: Repo.get!(WakfuItemType, id)

  @doc """
  Creates a wakfu_item_type.

  ## Examples

      iex> create_wakfu_item_type(%{field: value})
      {:ok, %WakfuItemType{}}

      iex> create_wakfu_item_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wakfu_item_type(attrs \\ %{}) do
    %WakfuItemType{}
    |> WakfuItemType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wakfu_item_type.

  ## Examples

      iex> update_wakfu_item_type(wakfu_item_type, %{field: new_value})
      {:ok, %WakfuItemType{}}

      iex> update_wakfu_item_type(wakfu_item_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wakfu_item_type(%WakfuItemType{} = wakfu_item_type, attrs) do
    wakfu_item_type
    |> WakfuItemType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wakfu_item_type.

  ## Examples

      iex> delete_wakfu_item_type(wakfu_item_type)
      {:ok, %WakfuItemType{}}

      iex> delete_wakfu_item_type(wakfu_item_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wakfu_item_type(%WakfuItemType{} = wakfu_item_type) do
    Repo.delete(wakfu_item_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wakfu_item_type changes.

  ## Examples

      iex> change_wakfu_item_type(wakfu_item_type)
      %Ecto.Changeset{data: %WakfuItemType{}}

  """
  def change_wakfu_item_type(%WakfuItemType{} = wakfu_item_type, attrs \\ %{}) do
    WakfuItemType.changeset(wakfu_item_type, attrs)
  end

  @doc """
  Imports all wakfu item_types from the Wakfu CDN.

  ## Examples

      iex> Novy.Wakfu.WakfuItemTypeDatasource.import_all_wakfu_item_types()
      {:ok, [%{}]}

  """
  def import_all_wakfu_item_types do
    {:ok, raw_datas} = Novy.Wakfu.Client.get("equipmentItemTypes")

    # Get current DateTime
    inserted_at = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    # Format the datas
    raw_datas
    |> Enum.map(fn raw_data ->
      %{
        id: raw_data["definition"]["id"],
        title_fr: raw_data["title"]["fr"],
        title_en: raw_data["title"]["en"],
        title_es: raw_data["title"]["es"],
        title_pt: raw_data["title"]["pt"],
        equipment_positions: raw_data["definition"]["equipmentPositions"],
        parent_id: raw_data["definition"]["parentId"] || nil,
        inserted_at: inserted_at,
        updated_at: inserted_at
      }
    end)
    |> Enum.chunk_every(1000)
    |> Enum.each(fn chunk ->
      Repo.insert_all(
        WakfuItemType,
        chunk,
        on_conflict: :replace_all,
        conflict_target: [:id]
      )
    end)
  end
end
