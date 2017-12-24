defmodule Day22.Grid do
  def parse(input) do
    points = input
      |> String.split("\n")
      |> Stream.with_index
      |> Stream.flat_map(fn {line, row} -> parse_line(line, row) end)
      |> Enum.to_list
    size = points |> length |> :math.sqrt
    center = round((size - 1) / 2)
    points
      |> Enum.map(fn {{row, col}, value} -> {{row - center, col - center}, value} end)
      |> Map.new
  end

  defp parse_line(line, row) do
    line
      |> String.split("", trim: true)
      |> Stream.with_index
      |> Stream.map(fn
           {".", col} -> {{row, col,}, :clean}
           {"#", col} -> {{row, col,}, :infected}
         end)
      |> Enum.to_list
  end

  @doc """
      iex> grid = \"\"\"
      iex> ..#
      iex> #..
      iex> ...
      iex> \"\"\" |> Day22.Grid.parse
      iex> {_, infected_count} = Day22.Grid.go(grid, 70, Day22.Part1)
      iex> infected_count
      41
      iex> {_, infected_count} = Day22.Grid.go(grid, 100, Day22.Part2)
      iex> infected_count
      26
  """
  def go(grid, bursts_count, rules) do
    go(grid, bursts_count, {0, 0}, :up, 0, rules)
  end

  defp go(grid, 0, _position, _direction, infected_count, _rules) do
    {grid, infected_count}
  end

  defp go(grid, bursts_count, position, direction, infected_count, rules) do
    new_direction = rules.new_direction(value_at(grid, position), direction)
    new_position = step(position, new_direction)
    {new_grid, action} = rules.update_at(grid, position)
    new_infected_count = if action == :infected, do: infected_count + 1, else: infected_count
    go(new_grid, bursts_count - 1, new_position, new_direction, new_infected_count, rules)
  end

  def value_at(grid, position) do
    case Map.fetch(grid, position) do
      {:ok, value} -> value
      :error -> :clean
    end
  end

  def step({row, col}, direction) do
    {x, y} = diff(direction)
    {row + x, col + y}
  end

  def turn_right(:up), do: :right
  def turn_right(:right), do: :down
  def turn_right(:down), do: :left
  def turn_right(:left), do: :up

  def turn_left(:up), do: :left
  def turn_left(:left), do: :down
  def turn_left(:down), do: :right
  def turn_left(:right), do: :up

  def reverse(:up), do: :down
  def reverse(:down), do: :up
  def reverse(:right), do: :left
  def reverse(:left), do: :right

  def diff(:up), do: {-1, 0}
  def diff(:right), do: {0, 1}
  def diff(:down), do: {1, 0}
  def diff(:left), do: {0, -1}
end
