defmodule Day10.Knot do
  @doc """
      iex> Day10.Knot.hash([0, 1, 2, 3, 4], [3])
      [2, 1, 0, 3, 4]
      iex> Day10.Knot.hash([0, 1, 2, 3, 4], [3, 4, 1, 5])
      [3, 4, 2, 1, 0]
  """
  def hash(list, lengths) do
    hash(list, lengths, 0, 0)
  end

  def hash(list, [], _current_position, _skip_size) do
    list
  end

  def hash(list, [current_length | rest_lengths], current_position, skip_size) do
    reversed_sublist = list
      |> sublist(current_position, current_length)
      |> Enum.reverse
    next_position = recursive_position(current_position + current_length + skip_size, length(list))
    list
      |> replace(reversed_sublist, current_position)
      |> hash(rest_lengths, next_position, skip_size + 1)
  end

  def recursive_position(position, list_length) do
    if position < list_length do
      position
    else
      recursive_position(position - list_length, list_length)
    end
  end

  @doc """
      iex> Day10.Knot.sublist([0, 1, 2, 3, 4], 0, 3)
      [0, 1, 2]
      iex> Day10.Knot.sublist([2, 1, 0, 3, 4], 3, 4)
      [3, 4, 2, 1]
      iex> Day10.Knot.sublist([4, 3, 0, 1, 2], 1, 1)
      [3]
      iex> Day10.Knot.sublist([4, 3, 0, 1, 2], 1, 5)
      [3, 0, 1, 2, 4]
  """
  def sublist(list, start_at, sublist_length) do
    slice = Enum.slice(list, start_at, sublist_length)
    slice_length = length(slice)
    if slice_length == sublist_length do
      slice
    else
      slice ++ sublist(list, 0, sublist_length - slice_length)
    end
  end

  @doc """
      iex> Day10.Knot.replace([0, 1, 2, 3, 4], ["a", "b"], 2)
      [0, 1, "a", "b", 4]
      iex> Day10.Knot.replace([0, 1, 2, 3, 4], ["a", "b", "c", "d"], 2)
      ["d", 1, "a", "b", "c"]
      iex> Day10.Knot.replace([0, 1, 2, 3, 4], ["a", "b", "c", "d", "e"], 3)
      ["c", "d", "e", "a", "b"]
  """
  def replace(list, [], _start_at) do
    list
  end

  def replace(list, [sublist_head | sublist_tail], start_at) do
    list
      |> List.replace_at(start_at, sublist_head)
      |> replace(sublist_tail, (if start_at + 1 < length(list), do: start_at + 1, else: 0))
  end
end
