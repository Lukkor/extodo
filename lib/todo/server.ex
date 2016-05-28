defmodule Todo.Server do
  @moduledoc"""
  Process which keeps Todo.List structures
  """

  use GenServer
  alias Todo.List

  @doc"""
  server interface
  """
  def start_link(name) do
    IO.puts "Starting Todo.Server server for #{name}"
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def via(name) do
    {:via, Todo.Registry, {:server, name}}
  end

  def whereis(name) do
    Todo.Registry.whereis_name({:server, name})
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @doc"""
  gen_server callbacks
  """
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || List.new}}
  end

  def handle_cast({:add_entry, entry}, {name, state}) do
    new_state = List.add_entry(state, entry)
     Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:entries, date}, _, {name, state}) do
    {:reply, List.entries(state, date), {name, state}}
  end

end
