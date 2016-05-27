defmodule Todo.Registry do
  @moduledoc"""
  Registry server which keeps knowledge of
  Todo.Database.Worker processes in an ETS table
  """

  use GenServer
  import Kernel, except: [send: 2]

  def start_link do
    IO.puts "Starting Todo.Registry server"
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  def register_name(key, pid) do
    GenServer.call(:registry, {:register_name, key, pid})
  end

  def unregister_name(key) do
    GenServer.call(:registry, {:unregister_name, key})
  end

  def whereis_name(key) do
    case :ets.lookup(:registry, key) do
      [{^key, pid}] -> pid
      _ -> :undefined
    end
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  @doc"""
  gen_server callbacks
  """
  def init(_) do
    :ets.new(:registry, [:named_table, :protected, :set])
    {:ok, nil}
  end

  def handle_call({:register_name, key, pid}, _, state) do
    if whereis_name(key) != :undefined do
      {:reply, :no, state}
    else
      Process.monitor(pid)
      :ets.insert(:registry, {key, pid})
      {:reply, :yes, state}
    end
  end

  def handle_call({:unregister_name, key}, state) do
    :ets.delete(:registry, key)
    {:reply, key, state}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    :ets.match_delete(:registry, {:_, pid})
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

end
