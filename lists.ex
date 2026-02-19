defmodule Lists do

  def add(numbers, base, false), do: numbers ++ [base]

  def add(numbers, base, true), do: [base | numbers]

  def delete(numbers, item), do: List.delete(numbers, item)

  def get(numbers), do: Enum.all?(numbers)

end

# Example usage:
numbers = [1, 2, 3]

IO.inspect(numbers = Lists.add(numbers, 4, false))
IO.inspect(numbers = Lists.add(numbers, 0, true))
