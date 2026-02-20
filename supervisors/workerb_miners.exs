defmodule WorkerB do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("Worker B is start mining")
    {:ok, %{}}
  end
end
