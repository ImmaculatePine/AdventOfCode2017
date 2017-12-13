defmodule Day10.Knot do
  import Bitwise
  @standard_length_suffix [17, 31, 73, 47, 23]

  @doc """
      iex> Day10.Knot.hash("")
      "a2582a3a0e66e6e86e3812dcb672a272"
      iex> Day10.Knot.hash("AoC 2017")
      "33efeb34ea91902bb2f59c9920caa6cd"
      iex> Day10.Knot.hash("1,2,3")
      "3efbe78a8d82f29979031a4aa0b16a9d"
      iex> Day10.Knot.hash("1,2,4")
      "63960835bcdc130f0b66d7ff4f6a5a8e"
  """
  def hash(string) do
    hash(Enum.to_list(0..255), String.to_charlist(string) ++ @standard_length_suffix)
  end

  def hash(list, lengths) do
    list
      |> get_sparse_hash(lengths)
      |> get_dense_hash
  end

  defp get_sparse_hash(list, lengths) do
    {sparse_hash, _, _} = 1..64
      |> Enum.to_list
      |> Enum.reduce({list, 0, 0}, fn (_, {acc, current_position, skip_size}) ->
        hash_round(acc, lengths, current_position, skip_size)
      end)
    sparse_hash
  end

  defp get_dense_hash(list) do
    list
      |> Enum.chunk_every(16)
      |> Enum.map(&xor_list/1)
      |> Enum.map(&(Integer.to_string(&1, 16)))
      |> Enum.map(&(String.pad_leading(&1, 2, "0")))
      |> Enum.map(&String.downcase/1)
      |> Enum.join("")
  end

  @doc """
      iex> Day10.Knot.xor_list([65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22])
      64
  """
  def xor_list([head | tail]) do
    xor_list(tail, head)
  end

  defp xor_list([], acc) do
    acc
  end

  defp xor_list([head | tail], acc) do
    xor_list(tail, bxor(acc, head))
  end

  @doc """
      iex> Day10.Knot.hash_round([0, 1, 2, 3, 4], [3])
      {[2, 1, 0, 3, 4], 3, 1}
      iex> Day10.Knot.hash_round([0, 1, 2, 3, 4], [3, 4, 1, 5])
      {[3, 4, 2, 1, 0], 4, 4}
  """
  def hash_round(list, lengths) do
    hash_round(list, lengths, 0, 0)
  end

  def hash_round(list, [], current_position, skip_size) do
    {list, current_position, skip_size}
  end

  def hash_round(list, [current_length | rest_lengths], current_position, skip_size) do
    reversed_sublist = list
      |> sublist(current_position, current_length)
      |> Enum.reverse
    next_position = recursive_position(current_position + current_length + skip_size, length(list))
    list
      |> replace(reversed_sublist, current_position)
      |> hash_round(rest_lengths, next_position, skip_size + 1)
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
