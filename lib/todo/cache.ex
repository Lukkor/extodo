defmodule Todo.Cache do
  @moduledoc"""
  Keeps knowledge and start Todo.Server
  """

  use GenServer

  def start_link do
    IO.puts "Starting Todo.Cache server"
    GenServer.start_link(__MODULE__, nil, name: :cache_server)
  end

  def server_process(server_name) do
    case Todo.Server.whereis(server_name) do
      :undefined ->
        GenServer.call(:cache_server, {:server_process, server_name})
      pid -> pid
    end
  end

  @doc"""
  gen_server callbacks
  """
  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, server_name}, _, state) do
    server_pid = case Todo.Server.whereis(server_name) do
      :undefined ->
        {:ok, pid} = Todo.ServersSupervisor.start_child(server_name)
        pid
      pid -> pid
    end

    {:reply, server_pid, state}
  end
end
