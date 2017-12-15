defmodule Day14.Defragmentation do
  alias Day10.Knot

  def build_grid(input) do
    0..127
     |> Enum.reduce(%{}, fn (row, acc) -> build_row(input, row, acc) end)
  end

  def build_row(input, row, grid) do
    "#{input}-#{row}"
      |> Knot.hash
      |> String.split("", trim: true)
      |> Enum.map(&hex_to_binary/1)
      |> Enum.join
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.zip(0..127)
      |> Enum.reduce(grid, fn ({value, col}, acc) -> Map.put(acc, {col, row}, value) end)
  end

  def hex_to_binary(hex) do
    {decimal, _} = Integer.parse(hex, 16)
    decimal
      |> Integer.to_string(2)
      |> String.pad_leading(4, "0")
  end

  def number_of_used_squares(grid) do
    grid
      |> Map.values
      |> Enum.filter(&(&1 == 1))
      |> length
  end

  @doc """
      iex> grid = %{{0, 0} => 0, {0, 1} => 1, {0, 2} => 1, {1, 0} => 1, {1, 1} => 0, {1, 2} => 1, {2, 0} => 1, {2, 1} => 0, {2, 2} => 0}
      iex> Day14.Defragmentation.number_of_groups(grid)
      2
  """
  def number_of_groups(grid) do
    non_empty_grid = grid
      |> Enum.filter(fn {_, value} -> value == 1 end)
      |> Map.new
    number_of_groups(non_empty_grid, Enum.to_list(non_empty_grid), 0, [])
  end

  defp number_of_groups(_grid, [], counter, _visited) do
    counter
  end

  defp number_of_groups(grid, [{{_, _}, 0} | tail], counter, visited) do
    number_of_groups(grid, tail, counter, visited)
  end

  defp number_of_groups(grid, [{pos = {_, _}, value} | tail], counter, visited) do
    if pos in visited do
      number_of_groups(grid, tail, counter, visited)
    else
      number_of_groups(grid, tail, counter + 1, visited ++ traverse(grid, pos))
    end
  end

  @doc """
      iex> grid = %{{0, 0} => 0, {0, 1} => 1, {0, 2} => 1, {1, 0} => 1, {1, 1} => 0, {1, 2} => 1, {2, 0} => 1, {2, 1} => 0, {2, 2} => 0}
      iex> Day14.Defragmentation.traverse(grid, {0, 1})
      [{1, 2}, {0, 1}, {0, 2}]
  """
  def traverse(grid, pos, traversed \\ []) do
    grid
      |> neighbour_squares(pos)
      |> Enum.filter(fn p ->
           case Map.fetch(grid, p) do
             {:ok, value} -> value == 1
             :error -> false
           end
         end)
      |> Enum.reduce(traversed, fn (p, acc) -> (if p in acc, do: acc, else: traverse(grid, p, [p | acc])) end)
  end

  defp neighbour_squares(_, {col, row}) do
    [
      {col, row - 1},
      {col, row + 1},
      {col - 1, row},
      {col + 1, row},
    ]
  end
end
