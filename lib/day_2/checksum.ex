defmodule Day2.Checksum do
  @doc """
      iex> input = \"\"\"
      iex> 5 1 9 5
      iex> 7 5 3
      iex> 2 4 6 8
      iex> \"\"\"
      iex> Day2.Checksum.calculate(input)
      18
  """
  def calculate(input) do
    input
      |> String.split("\n", trim: true)
      |> Enum.map(&row_checksum(&1))
      |> Enum.sum
  end

  defp row_checksum(row_input) do
    row = row_input
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&String.to_integer(&1))
    min = Enum.min(row)
    max = Enum.max(row)
    max - min
  end
end
