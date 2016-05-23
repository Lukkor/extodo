defmodule Todo.Cache do

  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, server_name) do
    GenServer.call(cache_pid, {:server_process, server_name})
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
