defmodule Day9.Stream do
  def read_file(filepath) do
    filepath
      |> File.read!
      |> read
  end

  @doc """
      iex> Day9.Stream.read("{}")
      1
      iex> Day9.Stream.read("{{{}}}")
      6
      iex> Day9.Stream.read("{{},{}}")
      5
      iex> Day9.Stream.read("{{{},{},{{}}}}")
      16
      iex> Day9.Stream.read("{<a>,<a>,<a>,<a>}")
      1
      iex> Day9.Stream.read("{{<ab>},{<ab>},{<ab>},{<ab>}}")
      9
      iex> Day9.Stream.read("{{<!!>},{<!!>},{<!!>},{<!!>}}")
      9
      iex> Day9.Stream.read("{{<a!>},{<a!>},{<a!>},{<ab>}}")
      3
  """
  def read(data) do
    data
    |> String.split("", trim: true)
    |> read(0, 0, false)
  end

  defp read([], score, _level, _garbaged) do
    score
  end

  defp read([head | tail], score, level, false) do
    case head do
      "{" -> read(tail, score, level + 1, false)
      "}" -> read(tail, score + level, level - 1, false)
      "<" -> read(tail, score, level, true)
      ">" -> read(tail, score, level, false)
      "!" -> ignore(tail, score, level, false)
      _ -> read(tail, score, level, false)
    end
  end

  defp read([head | tail], score, level, true) do
    case head do
      ">" -> read(tail, score, level, false)
      "!" -> ignore(tail, score, level, true)
      _ -> read(tail, score, level, true)
    end
  end

  defp ignore([_ | tail], score, level, garbaged) do
    read(tail, score, level, garbaged)
  end
end
