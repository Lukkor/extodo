defmodule Todo.List do

  alias Todo.List, as: List

  defstruct auto_id: 1, entries: HashDict.new

  def new, do: %List{}

  def new(entries \\ []) do
    for entry <- entries, into: List.new, do: entry
  end

  def add_entry(%List{entries: entries, auto_id: auto_id} = todolist, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = HashDict.put(entries, auto_id, entry)
    %List{todolist |
     entries: new_entries,
     auto_id: auto_id + 1
   }
  end

  def entries(%List{entries: entries}, date) do
    entries
    |> Stream.filter(fn ({_, entry}) -> entry.date == date end)
    |> Enum.map(fn ({_, entry}) -> entry end)
  end

  def entries(%List{entries: entries}) do
    entries
    |> Enum.map(fn ({_, entry}) -> entry end)
  end

  def update_entry(%List{entries: entries} = todolist, id, updater_fun) do
    case entries[id] do
      nil -> todolist
      entry ->
        new_entries = HashDict.put(entries, id, updater_fun.(entry))
        %List{todolist |
         entries: new_entries
       }
    end
  end

  def delete_entry(%List{entries: entries} = todolist, id) do
    case entries[id] do
      nil -> todolist
      _ ->
        new_entries = HashDict.delete(entries, id)
        %List{todolist |
         entries: new_entries
       }
    end
  end

  def count(%List{entries: entries}) do
    Enum.count(entries)
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
