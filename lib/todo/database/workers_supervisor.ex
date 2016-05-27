defmodule Todo.Database.WorkersSupervisor do
  @moduledoc"""
  Manage database workers
  """

  use Supervisor

  def start_link(db_folder, pool_size) do
    IO.puts "Starting Todo.Database.WorkersSupervisor supervisor"
    Supervisor.start_link(__MODULE__, {db_folder, pool_size})
  end

  def init({db_folder, pool_size}) do
    processes = for id <- 1..pool_size do
      worker(Todo.Database.Worker, [db_folder, id], id: {:database_worker, id})
    end

    supervise(processes, strategy: :one_for_one)
  end

end
