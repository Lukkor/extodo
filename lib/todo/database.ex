defmodule Todo.Database do

  use GenServer
  alias Todo.Database.Worker, as: Worker

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
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
    for index <- 0..2, into: HashDict.new do
      {:ok, pid} = Worker.start(db_folder)
      {index, pid}
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
    {:reply, HashDict.get(workers, key), workers}
  end

end
