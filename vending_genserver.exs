defmodule VendingMachine do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def insert_coin(amount), do: GenServer.cast(__MODULE__, {:coin, amount})
  def buy(), do: GenServer.call(__MODULE__, :buy)
  def restock(n), do: GenServer.cast(__MODULE__, {:restock, n})
  def status(), do: GenServer.call(__MODULE__, :status)

  @impl true
  def init(_args) do
    {:ok, %{stock: 3, balance: 0}}
  end

  @impl true
  def handle_cast({:coin, amount}, state) do
    IO.puts("Masuk uang #{amount}")

    {:noreply, %{state | balance: state.balance + amount}}
  end

  @impl true
  def handle_cast({:restock, n}, state) do
    IO.puts("Restock #{n}")

    {:noreply, %{state | stock: state.stock + n}}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state, state} #<- ini tuh response nya :beam_status, response_client, dan response_state baru
  end

  @impl true
  def handle_call(:buy, _from, %{stock: 0} = state) do
    IO.puts("Barang vending habis")
    {:reply, :empty, state}
  end

  @impl true
  def handle_call(:buy, _from, %{balance: b} = state) when b < 5 do
    IO.puts("Uang tidak cukup!")
    {:reply, :not_enough_money, state}
  end

  @impl true
  def handle_call(:buy, _from, state) do
    IO.puts("Minuman keluar!")

    new_state = %{state | stock: state.stock - 1, balance: state.balance - 5}

    {:reply, :ok, new_state}
  end
end

VendingMachine.start_link(nil)
VendingMachine.insert_coin(10)
VendingMachine.buy()
VendingMachine.buy()
VendingMachine.buy()
VendingMachine.buy()

# VendingMachine.buy() #this should be return :not_enough_money
