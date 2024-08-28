defmodule Novy.WakfuDatasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Novy.WakfuDatas` context.
  """

  @doc """
  Generate a wakfu_item.
  """
  def wakfu_item_fixture(attrs \\ %{}) do
    {:ok, wakfu_item} =
      attrs
      |> Enum.into(%{
        descritpion: "some descritpion",
        title: "some title"
      })
      |> Novy.WakfuDatas.create_wakfu_item()

    wakfu_item
  end
end
