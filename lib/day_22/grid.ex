defmodule Day22.Grid do
  @doc """
      iex> input = \"\"\"
      iex> ..#
      iex> #..
      iex> ...
      iex> \"\"\"
      iex> Day22.Grid.parse(input)
      %{{-1, -1} => 0, {-1, 0} => 0, {-1, 1} => 1, {0, -1} => 1, {0, 0} => 0, {0, 1} => 0, {1, -1} => 0, {1, 0} => 0, {1, 1} => 0}
  """
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
           {".", col} -> {{row, col,}, 0}
           {"#", col} -> {{row, col,}, 1}
         end)
      |> Enum.to_list
  end

  @doc """
      iex> input = \"\"\"
      iex> ..#
      iex> #..
      iex> ...
      iex> \"\"\"
      iex> {_, infected_count} = input |> Day22.Grid.parse |> Day22.Grid.go(70)
      iex> infected_count
      41
  """
  def go(grid, bursts_count) do
    go(grid, bursts_count, {0, 0}, :up, 0)
  end

  defp go(grid, 0, _position, _direction, infected_count) do
    {grid, infected_count}
  end

  defp go(grid, bursts_count, position, direction, infected_count) do
    new_direction = case grid |> value_at(position) do
      0 -> direction |> turn_left
      1 -> direction |> turn_right
    end
    new_position = step(position, new_direction)
    {new_grid, action} = update_at(grid, position)
    new_infected_count = if action == :infected, do: infected_count + 1, else: infected_count
    go(new_grid, bursts_count - 1, new_position, new_direction, new_infected_count)
  end

  def value_at(grid, position) do
    case Map.fetch(grid, position) do
      {:ok, value} -> value
      :error -> 0
    end
  end

  def update_at(grid, position) do
    case value_at(grid, position) do
      0 -> {Map.put(grid, position, 1), :infected}
      1 -> {Map.put(grid, position, 0), :cleaned}
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

  def diff(:up), do: {-1, 0}
  def diff(:right), do: {0, 1}
  def diff(:down), do: {1, 0}
  def diff(:left), do: {0, -1}
end
