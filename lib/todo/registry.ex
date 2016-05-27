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
    GenServer.cast(:registry, {:register_name, key, pid})
  end

  def unregister_name(key) do
    GenServer.cast(:registry, {:unregister_name, key})
  end

  def whereis_name(key) do
    case :ets.lookup(:registry, key) do
      [{^key, pid}] -> pid
      _ -> :undefined
    end
  end

  def send(key, message) do
    case whereis(key) do
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
    :ets.new(:registry, [])
    {:ok, nil}
  end

  def handle_call({:register_name, key, pid}, _, _) do
    if whereis(key) != :undefined do
      {:reply, :no, nil}
    else
      Process.monitor(pid)
      :ets.insert(:registry, {key, pid})
      {:reply, :yes, nil}
    end
  end

  def handle_call({:unregister_name, key}, _) do
    :ets.delete(:registry, key)
    {:reply, key, nil}
  end

  def handle_info({:DOWN, _, :process, pid, _}, _) do
    :ets.match_delete(:registry, {:_, pid})
    {:noreply, nil}
  end

  def handle_info(_, _), do: {:noreply, nil}

end
