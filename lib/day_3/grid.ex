defmodule Day3.Grid do
  require Integer

  @doc """
      iex> Day3.Grid.steps_to(1)
      0
      iex> Day3.Grid.steps_to(12)
      3
      iex> Day3.Grid.steps_to(23)
      2
      iex> Day3.Grid.steps_to(1024)
      31
  """
  def steps_to(value) do
    {bottom, left, top, right} = value |> side_size |> sides
    cond do
      value in bottom -> steps_to(value, bottom)
      value in left -> steps_to(value, left)
      value in top -> steps_to(value, top)
      value in right -> steps_to(value, right)
    end
  end

  def steps_to(value, first..last) do
    half_length = round((last - first + 1) / 2)
    mid = ((first + last) / 2) |> Float.floor |> round
    abs(value - mid) + half_length
  end

  @doc """
      iex> Day3.Grid.sides(3)
      {8..9, 6..7, 4..5, 2..3}
      iex> Day3.Grid.sides(5)
      {22..25, 18..21, 14..17, 10..13}
  """
  def sides(size) do
    rb = size * size
    lb = rb - size + 1
    lt = lb - size + 1
    rt = lt - size + 1
    {
      (lb + 1)..rb,
      (lt + 1)..lb,
      (rt + 1)..lt,
      (rt - size + 2)..rt
    }
  end

  @doc """
      iex> Day3.Grid.side_size(17)
      5
      iex> Day3.Grid.side_size(9)
      3
      iex> Day3.Grid.side_size(8)
      3
      iex> Day3.Grid.side_size(7)
      3
      iex> Day3.Grid.side_size(6)
      3
      iex> Day3.Grid.side_size(5)
      3
      iex> Day3.Grid.side_size(4)
      3
      iex> Day3.Grid.side_size(3)
      3
      iex> Day3.Grid.side_size(2)
      3
      iex> Day3.Grid.side_size(1)
      1
  """
  def side_size(value) do
    if Integer.is_even(value) do
      side_size(value + 1)
    else
      value |> :math.sqrt |> next_odd_integer
    end
  end

  @doc """
      iex> Day3.Grid.next_odd_integer(4.0)
      5
      iex> Day3.Grid.next_odd_integer(4.1)
      5
      iex> Day3.Grid.next_odd_integer(4.7)
      5
      iex> Day3.Grid.next_odd_integer(5.0)
      5
      iex> Day3.Grid.next_odd_integer(5.1)
      7
      iex> Day3.Grid.next_odd_integer(5.7)
      7
  """
  def next_odd_integer(value) do
    floor = value |> Float.floor |> round
    if Integer.is_even(floor) do
      floor + 1
    else
      if floor == value, do: floor, else: floor + 2
    end
  end
end
