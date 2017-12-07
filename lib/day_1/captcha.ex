defmodule Day1.Captcha do
  @doc """
      iex> alias Day1.Captcha
      iex> Captcha.solve("1122")
      3
      iex> Captcha.solve("1111")
      4
      iex> Captcha.solve("1234")
      0
      iex> Captcha.solve("91212129")
      9
  """
  def solve(input) do
    input
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> (&sum(&1, List.last(&1), 0)).()
  end

  defp sum([], _previous_item, sum) do
    sum
  end

  defp sum([head | tail], previous_item, sum) do
    acc = if head == previous_item, do: sum + head, else: sum
    sum(tail, head, acc)
  end
end
