defmodule PageCounter do
  use GenServer

  #client api
  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def visit do
    GenServer.cast(__MODULE__, :visit)
  end

  def total do
    GenServer.call(__MODULE__, :total)
  end

  #BEAM

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:visit, state) do
    new_state = state + 1
    IO.inspect("User membuka halaman! total #{new_state}")

    {:noreply, new_state}
  end

  @impl true
  def handle_call(:total, _from,  state) do
    {:reply, state, state}
  end
end


PageCounter.start_link(nil)

for _ <- 1..10 do
  spawn(fn -> PageCounter.visit() end)
end

PageCounter.total()
