defmodule Day21.Fractal do
  @initial_fractal [
    [1, 0, 1],
    [1, 1, 0],
    [0, 0, 0]
  ]

  @doc """
      iex> %{} |>
      iex> Day21.Rule.add("../.# => ##./#../...") |>
      iex> Day21.Rule.add(".#./..#/### => #..#/..../..../#..#") |>
      iex> Day21.Fractal.on_pixels_count(2)
      12
  """
  def on_pixels_count(rules, iterations_count) do
    rules
      |> iterate(iterations_count)
      |> Enum.map(fn row -> Enum.count(row, &(&1 == 0)) end)
      |> Enum.sum
  end

  @doc """
      iex> %{} |>
      iex> Day21.Rule.add("../.# => ##./#../...") |>
      iex> Day21.Rule.add(".#./..#/### => #..#/..../..../#..#") |>
      iex> Day21.Fractal.iterate(2)
      [[0, 0, 1, 0, 0, 1], [0, 1, 1, 0, 1, 1], [1, 1, 1, 1, 1, 1], [0, 0, 1, 0, 0, 1], [0, 1, 1, 0, 1, 1], [1, 1, 1, 1, 1, 1]]
  """
  def iterate(rules, times) do
    iterate(@initial_fractal, rules, times)
  end

  def iterate(pattern, _rules, 0), do: pattern

  def iterate(pattern, rules, times) when pattern |> length |> rem(2) == 0 do
    iterate(pattern, rules, times, 2)
  end

  def iterate(pattern, rules, times) when pattern |> length |> rem(3) == 0 do
    iterate(pattern, rules, times, 3)
  end

  def iterate(pattern, rules, times, chunk_size) do
    pattern
      |> chunk(chunk_size)
      |> Enum.map(fn subpattern -> Map.fetch!(rules, subpattern) end)
      |> unchunk(chunk_size)
      |> iterate(rules, times - 1)
  end

  @doc """
      iex> [[1, 2, 3], [4, 5, 6], [7, 8, 9]] |> Day21.Fractal.chunk(3)
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]]

      iex> [[1, 2, 3, 4], [5, 6 , 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]] |> Day21.Fractal.chunk(2)
      [[[1, 2], [5, 6]], [[3, 4], [7, 8]], [[9, 10], [13, 14]], [[11, 12], [15, 16]]]
  """
  def chunk(pattern, chunk_size) do
    pattern
      |> Enum.chunk_every(chunk_size)
      |> Enum.map(fn subchunk ->
        subchunk
          |> Enum.map(&(Enum.chunk_every(&1, chunk_size)))
          |> Enum.zip
          |> Enum.map(&Tuple.to_list/1)
      end)
      |> Enum.reduce([], fn subchunk, acc -> acc ++ subchunk end)
  end

  @doc """
      iex> [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]] |> Day21.Fractal.unchunk(3)
      [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      iex> [[[1, 2], [5, 6]], [[3, 4], [7, 8]], [[9, 10], [13, 14]], [[11, 12], [15, 16]]] |> Day21.Fractal.unchunk(2)
      [[1, 2, 3, 4], [5, 6 , 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
  """
  def unchunk(patterns, chunk_size) do
    patterns
      |> Enum.chunk_every(chunk_size)
      |> Enum.map(&Enum.zip/1)
      |> Enum.map(fn pattern -> Enum.map(pattern, fn tuple -> tuple |> Tuple.to_list |> List.flatten end) end)
      |> Enum.reduce([], fn subchunk, acc -> acc ++ subchunk end)
  end
end
