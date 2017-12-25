defmodule Day24.Component do
  @doc """
      iex> Day24.Component.parse("44/4")
      [44, 4]
  """
  def parse(input) do
    input
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
  end  
end
