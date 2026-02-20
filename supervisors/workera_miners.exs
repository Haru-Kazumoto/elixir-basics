defmodule WorkerA do
  use GenServer

  def start_link(_) do
    IO.puts("Worker A start mining")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def crash do
    GenServer.cast(__MODULE__, :crash)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast(:crash, state) do
    IO.puts("Worker A is in trouble!")
    raise "Worker A is in danger, BOOM!"
    {:noreply, state}
  end

  @impl true
  def handle_info({:crash, reason}, state) do
    IO.puts("Worker A is shutdown due to: #{reason}")
    {:noreply, state}
  end

  def child_spec(_init_arg) do
    %{
      id: __MODULE__,
      restart: :transient,
      shutdown: 5000,
      start: {__MODULE__, :start_link, [[]]},
      type: :worker
    }
  end

end
