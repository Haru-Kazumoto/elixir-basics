defmodule Recursions do

  #Count the number of elements in a list recursively
  def count([]), do: 0
  def count([_head | tail]), do: 1 + count(tail)

  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  def double_each([]) do
    []
  end

  def double_each([head | tail]) do
    [head * 2 | double_each(tail)]
  end

  def max([]), do: :infinity
  def max([head]), do: head
  def max([head | tail]) do
    max_tail = max(tail)
    if head > max_tail, do: head, else: max_tail
  end

end

IO.puts("Count of elements: #{Recursions.count([1, 2, 3, 4, 5])}")
IO.puts("Sum of elements: #{Recursions.sum([1, 2, 3, 4, 5])}")
IO.puts("Double each element: #{inspect(Recursions.double_each([1, 2, 3, 4, 5]))}")
IO.puts("Max element: #{Recursions.max([3, 1, 4, 1, 5, 9, 2, 6, 5])}") 
