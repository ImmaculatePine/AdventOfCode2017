defmodule Day3.SumSpiral do
  defstruct last_position: {0, 0}, grid: %{{0, 0} => 1}

  @doc """
      iex> Day3.SumSpiral.first_larger_value_than(15)
      23
      iex> Day3.SumSpiral.first_larger_value_than(70)
      122
  """
  def first_larger_value_than(n) do
    first_larger_value_than(n, %Day3.SumSpiral{})
  end

  defp first_larger_value_than(n, spiral = %Day3.SumSpiral{last_position: last_position, grid: grid}) do
    last_value = Map.fetch!(grid, last_position)
    if last_value > n do
      last_value
    else
      first_larger_value_than(n, next(spiral))
    end
  end

  @doc """
  Returns the spiral with the next element added to it
  """
  def next(%Day3.SumSpiral{last_position: last_position, grid: grid}) do
    next_position = next_position(last_position)
    %Day3.SumSpiral{
      last_position: next_position,
      grid: Map.put(grid, next_position, neighbours_sum(grid, next_position))
    }
  end

  def neighbours_sum(grid, position) do
    position
      |> neighbour_coordinates
      |> Enum.filter(fn pos -> Map.has_key?(grid, pos) end)
      |> Enum.map(fn pos -> Map.fetch!(grid, pos) end)
      |> Enum.sum
  end

  defp neighbour_coordinates({x, y}) do
    [
      {x - 1, y - 1},
      {x,     y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x,     y + 1},
      {x + 1, y + 1}
    ]
  end

  @doc """
      iex> Enum.reduce(1..15, [{0, 0}], fn _, acc = [prev | _] -> [Day3.SumSpiral.next_position(prev) | acc] end)
      [{-1, 2}, {0, 2}, {1, 2}, {2, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {0, 0}]
  """
  def next_position({0, 0}), do: {1, 0}
  def next_position({x, y}) when x >= 0 and y >= 0 and x > y, do: {x, y + 1}
  def next_position({x, y}) when x >= 0 and y >= 0 and x <= y, do: {x - 1, y}

  def next_position({x, y}) when x <= 0 and y >= 0 and abs(x) < abs(y), do: {x - 1, y}
  def next_position({x, y}) when x <= 0 and y >= 0 and abs(x) >= abs(y), do: {x, y - 1}

  def next_position({x, y}) when x <= 0 and y <= 0 and abs(x) > abs(y), do: {x, y - 1}
  def next_position({x, y}) when x <= 0 and y <= 0 and abs(x) <= abs(y), do: {x + 1, y}

  def next_position({x, y}) when x >= 0 and y <= 0 and abs(x) <= abs(y), do: {x + 1, y}
  def next_position({x, y}) when x >= 0 and y <= 0 and abs(x) > abs(y), do: {x, y + 1}
end
