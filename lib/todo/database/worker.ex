defmodule Todo.Database.Worker do
  @moduledoc"""
  Actual Todo.Database worker which handle writing
  and reading stored Todo.List from files
  """

  use GenServer
  alias Todo.Registry

  def start_link(db_folder, id) do
    IO.puts "Starting Todo.Database.Worker server"
    GenServer.start_link(__MODULE__, db_folder, name: Registry.register())
  end

  def get(id, key) do
    GenServer.call(via(id), {:get, key})
  end

  def store(id, key, data) do
    GenServer.cast(via(id), {:store, key, data})
  end

  def via(id) do
    {:via, Todo.Registry, {:database_worker, id}}
  end

  @doc"""
  gen_server callbacks
  """
  def init(db_folder) do
    {:ok, db_folder}
  end

  def handle_call({:get, key}, _, db_folder) do
    data = case File.read(file_name(db_folder, key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    {:reply, data, db_folder}
  end

  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"

end
