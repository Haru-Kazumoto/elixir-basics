defmodule FlashSale do
  use GenServer

  #CLIENT API
  def start_link(stock) do
    GenServer.start_link(FlashSale, stock, name: FlashSale)
  end

  @impl true
  def init(stock) do
    IO.puts("Flash sale dimulai dengan stok #{stock}")
    {:ok, stock}
  end

  def buy do
    GenServer.call(FlashSale, :buy)
  end

  defp minus_stock(stock) when stock > 0 and is_integer(stock) do
    stock - 1
  end

  @impl true
  def handle_call(:buy, _from, 0) do
    {:reply, :sold_out, 0}
  end

  def handle_call(:buy, {pid, _}, stock) do
    IO.puts("User #{inspect(pid)} berhasil beli!, sisa stock #{minus_stock(stock)}")
    {:reply, :buyed!, minus_stock(stock)}
  end
end

FlashSale.start_link(2)

1..1_000
|> Task.async_stream(fn _ -> FlashSale.buy() end, max_concurrency: 100)
|> Enum.to_list()
