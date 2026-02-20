defmodule SomeWorkers do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :some_worker)
  end

  def explode do
    GenServer.call(:some_worker, :explode)
  end

  @impl true
  def init(state) do
    IO.puts("Worker started with pid #{inspect(selft())}")
    {:ok, state}
  end

  @impl true
  def handle_call(:explode, _from, state) do
    IO.puts("BOOM! WORKER HAS CRASHED")
    raise "something is wrong!"
    {:reply, :ok, state}
  end
end
