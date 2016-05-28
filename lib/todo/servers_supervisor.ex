defmodule Todo.ServersSupervisor do
  @moduledoc"""
  Supervise Todo.Server creation
  """

  use Supervisor

  def start_link do
    IO.puts "Starting Todo.ServersSupervisor server"
    Supervisor.start_link(__MODULE__, nil, name: :servers_supervisor)
  end

  def start_child(list_name) do
    Supervisor.start_child(:servers_supervisor, [list_name])
  end

  def init(_) do
    supervise([worker(Todo.Server, [])], strategy: :simple_one_for_one)
  end

end
