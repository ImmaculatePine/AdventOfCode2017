defmodule Day15.Generator do
  use Bitwise

  @doc """
      iex> Day15.Generator.judge(65, 8921, 5)
      1
      iex> Day15.Generator.judge({65, 4}, {8921, 8}, 5)
      0
  """
  def judge({start_a, mult_a}, {start_b, mult_b}, rounds) do
    judge({start_a, 16807, mult_a}, {start_b, 48271, mult_b}, 0, rounds)
  end

  def judge(start_a, start_b, rounds) do
    judge({start_a, 16807}, {start_b, 48271}, 0, rounds)
  end

  defp judge(_, _, score, 0) do
    score
  end

  defp judge(gen_a, gen_b, score, rounds_left) do
    next_gen_a = next(gen_a)
    next_gen_b = next(gen_b)
    if matched?(next_gen_a, next_gen_b) do
      judge(next_gen_a, next_gen_b, score + 1, rounds_left - 1)
    else
      judge(next_gen_a, next_gen_b, score, rounds_left - 1)
    end
  end

  @doc """
      iex> Day15.Generator.next({65, 16807})
      {1092455, 16807}
      iex> Day15.Generator.next({8921, 48271})
      {430625591, 48271}
  """
  def next({value, factor}) do
    {rem(value * factor, 2147483647), factor}
  end

  @doc """
      iex> Day15.Generator.next({65, 16807, 4})
      {1352636452, 16807, 4}
      iex> Day15.Generator.next({8921, 48271, 8})
      {1233683848, 48271, 8}
  """
  def next({value, factor, multiplier}) do
    new_value = rem(value * factor, 2147483647)
    if rem(new_value, multiplier) == 0 do
      {new_value, factor, multiplier}
    else
      next({new_value, factor, multiplier})
    end
  end

  def matched?({value_1, _}, {value_2, _}), do: matched?(value_1, value_2)
  def matched?({value_1, _, _}, {value_2, _, _}), do: matched?(value_1, value_2)
  def matched?(value_1, value_2), do: (value_1 &&& 0xffff) == (value_2 &&& 0xffff)
end
