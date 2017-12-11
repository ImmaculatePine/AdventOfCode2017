defmodule Day9.Stream do
  def read_file(filepath) do
    filepath
      |> File.read!
      |> read
  end

  @doc """
      iex> Day9.Stream.read("{}")
      {1, 0}
      iex> Day9.Stream.read("{{{}}}")
      {6, 0}
      iex> Day9.Stream.read("{{},{}}")
      {5, 0}
      iex> Day9.Stream.read("{{{},{},{{}}}}")
      {16, 0}
      iex> Day9.Stream.read("{<a>,<a>,<a>,<a>}")
      {1, 4}
      iex> Day9.Stream.read("{{<ab>},{<ab>},{<ab>},{<ab>}}")
      {9, 8}
      iex> Day9.Stream.read("{{<!!>},{<!!>},{<!!>},{<!!>}}")
      {9, 0}
      iex> Day9.Stream.read("{{<a!>},{<a!>},{<a!>},{<ab>}}")
      {3, 17}
  """
  def read(data) do
    data
    |> String.split("", trim: true)
    |> read(0, 0, 0, false)
  end

  defp read([], score, _level, garbage_counter, _garbaged) do
    {score, garbage_counter}
  end

  defp read([head | tail], score, level, garbage_counter, false) do
    case head do
      "{" -> read(tail, score, level + 1, garbage_counter, false)
      "}" -> read(tail, score + level, level - 1, garbage_counter, false)
      "<" -> read(tail, score, level, garbage_counter, true)
      ">" -> read(tail, score, level, garbage_counter, false)
      "!" -> ignore(tail, score, level, garbage_counter, false)
      _ -> read(tail, score, level, garbage_counter, false)
    end
  end

  defp read([head | tail], score, level, garbage_counter, true) do
    case head do
      ">" -> read(tail, score, level, garbage_counter, false)
      "!" -> ignore(tail, score, level, garbage_counter, true)
      _ -> read(tail, score, level, garbage_counter + 1, true)
    end
  end

  defp ignore([_ | tail], score, level, garbage_counter, garbaged) do
    read(tail, score, level, garbage_counter, garbaged)
  end
end
