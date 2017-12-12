defmodule Day1.Captcha do
  def parse(input) do
    input
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))
  end

  @doc """
      iex> Day1.Captcha.solve("1122")
      3
      iex> Day1.Captcha.solve("1111")
      4
      iex> Day1.Captcha.solve("1234")
      0
      iex> Day1.Captcha.solve("91212129")
      9
  """
  def solve(input) do
    input
      |> parse
      |> sum(0, 0, 1)
  end

  @doc """
      iex> Day1.Captcha.solve2("1212")
      6
      iex> Day1.Captcha.solve2("1221")
      0
      iex> Day1.Captcha.solve2("123425")
      4
      iex> Day1.Captcha.solve2("123123")
      12
      iex> Day1.Captcha.solve2("12131415")
      4
  """
  def solve2(input) do
    list = parse(input)
    sum(list, 0, 0, round(length(list) / 2))
  end

  def sum(list, current_position, sum, offset) do
    if current_position < length(list) do
      current_element = at(list, current_position)
      next_element = at(list, current_position + offset)
      acc = if current_element == next_element, do: sum + current_element, else: sum
      sum(list, current_position + 1, acc, offset)
    else
      sum
    end
  end

  @doc """
      iex> Day1.Captcha.at([1, 2, 3], 1)
      2
      iex> Day1.Captcha.at([1, 2, 3], 10)
      2
  """
  def at(list, position) do
    if position < length(list) do
      Enum.at(list, position)
    else
      at(list, position - length(list))
    end
  end
end
