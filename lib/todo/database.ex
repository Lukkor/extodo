defmodule Todo.Database do

  use GenServer
  alias Todo.Database.Worker, as: Worker

  def start_link(db_folder) do
    IO.puts "Starting Todo.Database server"
    GenServer.start_link(__MODULE__, db_folder, name: :database_server)
  end

  def get(key) do
    key |> get_worker |> Worker.get(key)
  end

  def store(key, data) do
    key |> get_worker |> Worker.store(key, data)
  end

  defp get_worker(key) do
    GenServer.call(:database_server, {:get_worker, key})
  end

  defp create_workers(db_folder) do
    for index <- 1..3, into: Map.new do
      {:ok, pid} = Worker.start_link(db_folder)
      {index - 1, pid}
    end
  end

  @doc"""
  gen_server callbacks
  """
  def init(db_folder) do
    File.mkdir_p(db_folder)
    {:ok, create_workers(db_folder)}
  end

  def handle_call({:get_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end

end
