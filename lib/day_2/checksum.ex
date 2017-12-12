defmodule Day2.Checksum do
  def read(filepath) do
    filepath
      |> File.stream!
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(fn line -> line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
      |> Enum.to_list
  end

  @doc """
      iex> Day2.Checksum.calculate([[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]])
      18
  """
  def calculate(input) do
    input
      |> Enum.map(&(Enum.max(&1) - Enum.min(&1)))
      |> Enum.sum
  end

  @doc """
      iex> Day2.Checksum.calculate2([[5, 9, 2, 8], [9, 4, 7, 3], [3, 8, 6, 5]])
      9
  """
  def calculate2(input) do
    input
      |> Enum.map(&find_dividable_pair/1)
      |> Enum.map(fn {x, y} -> x / y end)
      |> Enum.sum
      |> round
  end

  @doc """
    iex> Day2.Checksum.find_dividable_pair([5, 9, 2, 8])
    {8, 2}
    iex> Day2.Checksum.find_dividable_pair([9, 4, 7, 3])
    {9, 3}
    iex> Day2.Checksum.find_dividable_pair([3, 8, 6, 5])
    {6, 3}
  """
  def find_dividable_pair(list) do
    [pair] = for x <- list, y <- list, x > y && rem(x, y) == 0, do: {x, y}
    pair
  end
end
