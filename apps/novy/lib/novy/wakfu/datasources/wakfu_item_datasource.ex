defmodule Novy.Wakfu.WakfuItemDatasource do
  @moduledoc """
  The WakfuDatas context.
  """

  import Ecto.Query, warn: false
  alias Novy.Repo

  alias Novy.Wakfu.WakfuItemEntity, as: WakfuItem

  @doc """
  Returns the list of wakfu_items.

  ## Examples

      iex> list_wakfu_items()
      [%WakfuItem{}, ...]

  """
  def list_wakfu_items do
    Repo.all(WakfuItem)
  end

  @doc """
  Gets a single wakfu_item.

  Raises `Ecto.NoResultsError` if the Wakfu item does not exist.

  ## Examples

      iex> get_wakfu_item!(123)
      %WakfuItem{}

      iex> get_wakfu_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wakfu_item!(id), do: Repo.get!(WakfuItem, id)

  @doc """
  Creates a wakfu_item.

  ## Examples

      iex> create_wakfu_item(%{field: value})
      {:ok, %WakfuItem{}}

      iex> create_wakfu_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wakfu_item(attrs \\ %{}) do
    %WakfuItem{}
    |> WakfuItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wakfu_item.

  ## Examples

      iex> update_wakfu_item(wakfu_item, %{field: new_value})
      {:ok, %WakfuItem{}}

      iex> update_wakfu_item(wakfu_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wakfu_item(%WakfuItem{} = wakfu_item, attrs) do
    wakfu_item
    |> WakfuItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wakfu_item.

  ## Examples

      iex> delete_wakfu_item(wakfu_item)
      {:ok, %WakfuItem{}}

      iex> delete_wakfu_item(wakfu_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wakfu_item(%WakfuItem{} = wakfu_item) do
    Repo.delete(wakfu_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wakfu_item changes.

  ## Examples

      iex> change_wakfu_item(wakfu_item)
      %Ecto.Changeset{data: %WakfuItem{}}

  """
  def change_wakfu_item(%WakfuItem{} = wakfu_item, attrs \\ %{}) do
    WakfuItem.changeset(wakfu_item, attrs)
  end


  @doc """
  Imports all wakfu items from the Wakfu CDN.

  ## Examples

      iex> Novy.Wakfu.WakfuItemDatasource.import_all_wakfu_items()
      {:ok, [%{}]}

  """
  def import_all_wakfu_items do
    {:ok, raw_datas} = Novy.Wakfu.Client.get("items")

    # Get current DateTime
    inserted_at = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    # Format the datas
    raw_datas
    |> Enum.map(fn raw_data ->
      %{
        id: raw_data["definition"]["item"]["id"],
        title_fr: raw_data["title"]["fr"],
        title_en: raw_data["title"]["en"],
        title_es: raw_data["title"]["es"],
        title_pt: raw_data["title"]["pt"],
        description_fr: raw_data["description"]["fr"],
        description_en: raw_data["description"]["en"],
        description_es: raw_data["description"]["es"],
        description_pt: raw_data["description"]["pt"],
        level: raw_data["definition"]["item"]["level"],
        rarity: raw_data["definition"]["item"]["baseParameters"]["rarity"],
        type_id: raw_data["definition"]["item"]["baseParameters"]["itemTypeId"],
        inserted_at: inserted_at,
        updated_at: inserted_at
      }
    end)
    |> Enum.chunk_every(1000)
    |> Enum.each(fn chunk ->
      Repo.insert_all(WakfuItem, chunk)
    end)
  end

end
