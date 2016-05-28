defmodule Todo.Database do
  @moduledoc"""
  Write (trhough workers) Todo entries in files
  """

  @pool_size 3

  alias Todo.Database.{Worker, WorkersSupervisor}

  def start_link(db_folder) do
    WorkersSupervisor.start_link(db_folder, @pool_size)
  end

  def get(key) do
    key |> get_worker |> Worker.get(key)
  end

  def store(key, data) do
    key |> get_worker |> Worker.store(key, data)
  end

  defp get_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end

end
