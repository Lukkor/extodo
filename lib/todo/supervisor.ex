defmodule Todo.Supervisor do
  @moduledoc"""
  Supervise all Todo application
  """

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    processes = [
      worker(Todo.Registry, []),
      worker(Todo.Database, ["./persist/"]),
      worker(Todo.Cache, [])
    ]

    supervise(processes, strategy: :one_for_one)
  end

end
