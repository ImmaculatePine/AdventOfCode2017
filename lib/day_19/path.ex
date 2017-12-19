defmodule Day19.Path do
  @sample """
      |          
      |  +--+    
      A  |  C    
  F---|----E|--+ 
      |  |  |  D 
      +B-+  +--+ 
  """

  def sample do
    @sample
  end

  def parse(input) do
    input
      |> String.split("\n", trim: true)
      |> Stream.with_index
      |> Stream.flat_map(&parse_line/1)
      |> Stream.reject(fn {_, value} -> value == " " end)
      |> Enum.to_list
      |> Map.new
  end

  def parse_line({line, row}) do
    line
      |> String.split("", trim: true)
      |> Stream.with_index
      |> Stream.map(&(parse_cell(&1, row)))
      |> Enum.to_list
  end

  def parse_cell({value, col}, row) do
    {{row, col}, value}
  end

  @doc """
      iex> Day19.Path.sample |> Day19.Path.parse |> Day19.Path.traverse
      {["A", "B", "C", "D", "E", "F"], 38}
  """
  def traverse(path) do
    traverse(path, find_start(path), :down, 0, [])
  end

  defp traverse(path, current_position, direction, steps_counter, collected_items) do
    new_collection = collect(path, current_position, collected_items)
    case next_position(path, current_position, direction) do
      nil -> {Enum.reverse(new_collection), steps_counter + 1}
      {dir, pos} -> traverse(path, pos, dir, steps_counter + 1, new_collection)
    end
  end

  def collect(path, position, collected) do
    case Map.fetch(path, position) do
      {:ok, symbol} when symbol in ["|", "-", "+"] -> collected
      {:ok, letter} -> [letter | collected]
      :error -> collected
    end
  end

  @doc """
      iex> Day19.Path.sample |> Day19.Path.parse |> Day19.Path.find_start
      {0, 4}
  """
  def find_start(path) do
    {pos, _} = Enum.find(path, fn {{row, _}, value} -> row == 0 && value == "|" end)
    pos
  end

  @doc """
      iex> path = Day19.Path.sample |> Day19.Path.parse
      iex> Day19.Path.next_position(path, {0, 4}, :down)
      {:down, {1, 4}}
      iex> Day19.Path.next_position(path, {3, 4}, :down)
      {:down, {4, 4}}
      iex> Day19.Path.next_position(path, {1, 7}, :up)
      {:right, {1, 8}}
  """
  def next_position(path, position, direction) do
    path
      |> neighbour_positions(position, direction)
      |> select_next_position(direction)
  end

  defp neighbour_positions(path, {row, col}, direction) do
    [{:up, {row - 1, col}}, {:down, {row + 1, col}}, {:left, {row, col - 1}}, {:right, {row, col + 1}}]
      |> Enum.filter(fn {_, pos} -> Map.has_key?(path, pos) end)
      |> Enum.reject(fn {dir, _} -> dir == opposite(direction) end)
      |> Map.new
  end

  defp select_next_position(positions, _) when positions == %{}, do: nil

  defp select_next_position(positions, direction) do
    case Map.fetch(positions, direction) do
      {:ok, pos} -> {direction, pos}
      :error -> positions |> Map.to_list |> List.first
    end
  end

  defp opposite(:up), do: :down
  defp opposite(:down), do: :up
  defp opposite(:left), do: :right
  defp opposite(:right), do: :left
end
