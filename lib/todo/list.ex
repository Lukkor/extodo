defmodule Todo.List do
  @moduledoc"""
  Defines Todo.List structure and associated functions
  """

  alias Todo.List, as: List

  defstruct auto_id: 1, entries: HashDict.new

  def new(new_entries \\ []) do
    Enum.reduce(new_entries, %List{}, &add_entry(&2, &1))
  end

  def add_entry(%List{entries: current_entries, auto_id: auto_id} = todolist, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = HashDict.put(current_entries, auto_id, entry)
    %List{todolist |
     entries: new_entries,
     auto_id: auto_id + 1
   }
  end

  def entries(%List{entries: current_entries}, date) do
    current_entries
    |> Stream.filter(fn ({_, entry}) -> entry.date == date end)
    |> Enum.map(fn ({_, entry}) -> entry end)
  end

  def entries(%List{entries: current_entries}) do
    current_entries
    |> Enum.map(fn ({_, entry}) -> entry end)
  end

  def update_entry(%List{entries: current_entries} = todolist, id, updater_fun) do
    case current_entries[id] do
      nil -> todolist
      entry ->
        new_entries = HashDict.put(current_entries, id, updater_fun.(entry))
        %List{todolist |
         entries: new_entries
       }
    end
  end

  def delete_entry(%List{entries: current_entries} = todolist, id) do
    case current_entries[id] do
      nil -> todolist
      _ ->
        new_entries = HashDict.delete(current_entries, id)
        %List{todolist |
         entries: new_entries
       }
    end
  end

  def count(%List{entries: current_entries}) do
    Enum.count(current_entries)
  end

end

defimpl Collectable, for: Todo.List do

  alias Todo.List, as: List

  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todolist, {:cont, entry}) do
    List.add_entry(todolist, entry)
  end

  defp into_callback(todolist, :done), do: todolist
  defp into_callback(_, :halt), do: :ok

end
