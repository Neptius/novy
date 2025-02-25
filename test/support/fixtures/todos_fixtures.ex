defmodule Novy.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Novy.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: true,
        description: "some description",
        title: "some title"
      })
      |> Novy.Todos.create_todo()

    todo
  end
end
