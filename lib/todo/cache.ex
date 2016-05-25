defmodule Todo.Cache do

  use GenServer

  def start_link do
    IO.puts "Starting Todo.Cache server"
    GenServer.start_link(__MODULE__, nil, name: :cache_server)
  end

  def server_process(server_name) do
    GenServer.call(:cache_server, {:server_process, server_name})
  end

  @doc"""
  gen_server callbacks
  """
  def init(_) do
    Todo.Database.start("./persist/")
    {:ok, HashDict.new}
  end

  def handle_call({:server_process, server_name}, _, state) do
    case HashDict.fetch(state, server_name) do
      {:ok, server} ->
        {:reply, server, state}
      :error ->
        {:ok, new_server} = Todo.Server.start(server_name)
        {:reply, new_server, HashDict.put(state, server_name, new_server)}
    end
  end
end
