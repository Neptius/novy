defmodule Novy.WakfuDatasTest do
  use Novy.DataCase

  alias Novy.WakfuDatas

  describe "wakfu_items" do
    alias Novy.WakfuDatas.WakfuItem

    import Novy.WakfuDatasFixtures

    @invalid_attrs %{title: nil, descritpion: nil}

    test "list_wakfu_items/0 returns all wakfu_items" do
      wakfu_item = wakfu_item_fixture()
      assert WakfuDatas.list_wakfu_items() == [wakfu_item]
    end

    test "get_wakfu_item!/1 returns the wakfu_item with given id" do
      wakfu_item = wakfu_item_fixture()
      assert WakfuDatas.get_wakfu_item!(wakfu_item.id) == wakfu_item
    end

    test "create_wakfu_item/1 with valid data creates a wakfu_item" do
      valid_attrs = %{title: "some title", descritpion: "some descritpion"}

      assert {:ok, %WakfuItem{} = wakfu_item} = WakfuDatas.create_wakfu_item(valid_attrs)
      assert wakfu_item.title == "some title"
      assert wakfu_item.descritpion == "some descritpion"
    end

    test "create_wakfu_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WakfuDatas.create_wakfu_item(@invalid_attrs)
    end

    test "update_wakfu_item/2 with valid data updates the wakfu_item" do
      wakfu_item = wakfu_item_fixture()
      update_attrs = %{title: "some updated title", descritpion: "some updated descritpion"}

      assert {:ok, %WakfuItem{} = wakfu_item} = WakfuDatas.update_wakfu_item(wakfu_item, update_attrs)
      assert wakfu_item.title == "some updated title"
      assert wakfu_item.descritpion == "some updated descritpion"
    end

    test "update_wakfu_item/2 with invalid data returns error changeset" do
      wakfu_item = wakfu_item_fixture()
      assert {:error, %Ecto.Changeset{}} = WakfuDatas.update_wakfu_item(wakfu_item, @invalid_attrs)
      assert wakfu_item == WakfuDatas.get_wakfu_item!(wakfu_item.id)
    end

    test "delete_wakfu_item/1 deletes the wakfu_item" do
      wakfu_item = wakfu_item_fixture()
      assert {:ok, %WakfuItem{}} = WakfuDatas.delete_wakfu_item(wakfu_item)
      assert_raise Ecto.NoResultsError, fn -> WakfuDatas.get_wakfu_item!(wakfu_item.id) end
    end

    test "change_wakfu_item/1 returns a wakfu_item changeset" do
      wakfu_item = wakfu_item_fixture()
      assert %Ecto.Changeset{} = WakfuDatas.change_wakfu_item(wakfu_item)
    end
  end
end
