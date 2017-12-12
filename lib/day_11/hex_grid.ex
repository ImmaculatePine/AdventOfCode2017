defmodule Day11.HexGrid do
  def read(filepath) do
    filepath
      |> File.read!
      |> go
  end

  @doc """
      iex> Day11.HexGrid.go("ne,ne,ne")
      {3, 3}
      iex> Day11.HexGrid.go("ne,ne,sw,sw")
      {0, 2}
      iex> Day11.HexGrid.go("ne,ne,s,s")
      {2, 2}
      iex> Day11.HexGrid.go("se,sw,se,sw,sw")
      {3, 3}
  """
  def go(instructions) do
    {coords, max_offset} = instructions
      |> String.split(",")
      |> Enum.reduce({{0, 0, 0}, 0}, fn (direction, acc) -> step(acc, direction) end)
    {max(coords), max_offset}
  end

  def step({{x, y, z}, max_offset}, direction) do
    coords = case direction do
      "n"  -> {x,     y + 1, z - 1}
      "s"  -> {x,     y - 1, z + 1}
      "ne" -> {x - 1, y + 1, z}
      "nw" -> {x + 1, y,     z - 1}
      "se" -> {x - 1, y,     z + 1}
      "sw" -> {x + 1, y - 1, z}
    end
    {coords, Enum.max([max(coords), max_offset])}
  end

  def max(coords) when is_tuple(coords) do
    coords
      |> Tuple.to_list
      |> Enum.map(&abs/1)
      |> Enum.max
  end
end
