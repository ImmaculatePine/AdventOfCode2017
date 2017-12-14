defmodule Day14.Defragmentation do
  def build_grid(input) do
    Enum.map(0..127, &(build_row("#{input}-#{&1}")))
  end

  def build_row(input) do
    input
      |> Day10.Knot.hash
      |> String.split("", trim: true)
      |> Enum.map(&hex_to_binary/1)
      |> Enum.join
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  def hex_to_binary(hex) do
    {decimal, _} = Integer.parse(hex, 16)
    decimal
      |> Integer.to_string(2)
      |> String.pad_leading(4, "0")
  end

  def number_of_used_squares(grid) do
    grid
      |> Enum.map(fn row -> row |> Enum.filter(&(&1 == 1)) |> length end)
      |> Enum.sum
  end
end
