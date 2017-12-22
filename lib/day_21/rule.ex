defmodule Day21.Rule do
  @transformations [
    &Day21.Rule.flip_vertical/1,
    &Day21.Rule.flip_horizontal/1,
    &Day21.Rule.rotate_cw/1,
    {&Day21.Rule.rotate_cw/2, 2},
    {&Day21.Rule.rotate_cw/2, 3}
  ]

  def transformation_pairs do
    for t1 <- @transformations, t2 <- @transformations, t1 != t2 do
      [t1, t2]
    end
  end

  def transformations do
    Enum.map(@transformations, &([&1])) ++ transformation_pairs()
  end

  def transformations(pattern) do
    transformations()
      |> Enum.reduce([], fn fun, acc -> [transform(pattern, fun) | acc] end)
      |> Enum.uniq
  end

  def transform(pattern, []) do
    pattern
  end

  def transform(pattern, [fun | rest]) do
    pattern
      |> transform(fun)
      |> transform(rest)
  end

  def transform(pattern, {fun, args}) do
    fun.(pattern, args)
  end

  def transform(pattern, fun) do
    fun.(pattern)
  end

  @doc """
      iex> Day21.Rule.add(%{}, "../.# => ##./#../...")
      %{[[0, 1], [1, 1]] => [[0, 0, 1], [0, 1, 1], [1, 1, 1]],
        [[1, 0], [1, 1]] => [[0, 0, 1], [0, 1, 1], [1, 1, 1]],
        [[1, 1], [0, 1]] => [[0, 0, 1], [0, 1, 1], [1, 1, 1]],
        [[1, 1], [1, 0]] => [[0, 0, 1], [0, 1, 1], [1, 1, 1]]}
  """
  def add(rules, input) when is_binary(input) do
    add(rules, parse(input))
  end

  def add(rules, {from, to}) do
    transformations(from)
      |> Enum.reduce(rules, fn transformed_from, acc -> Map.put(acc, transformed_from, to) end)
      |> Map.put(from, to)
  end

  @doc """
      iex> Day21.Rule.parse("../.. => .##/.##/###")
      {[[1, 1], [1, 1]], [[1, 0, 0], [1, 0, 0], [0, 0, 0]]}
  """
  def parse(input) when is_binary(input) do
    ~r/(.+) => (.+)/
      |> Regex.run(input)
      |> parse
  end

  def parse([_, from, to]) do
    {parse_pattern(from), parse_pattern(to)}
  end

  @doc """
      iex> Day21.Rule.parse_pattern("../.#")
      [[1, 1], [1, 0]]
  """
  def parse_pattern(pattern) do
    pattern
      |> String.split("/")
      |> Enum.map(fn line -> line |> String.split("", trim: true) |> Enum.map(&to_integer/1) end)
  end

  defp to_integer("."), do: 1
  defp to_integer("#"), do: 0

  @doc """
      iex> Day21.Rule.flip_vertical([[1, 0, 1], [1, 1, 1], [0, 1, 1]])
      [[0, 1, 1], [1, 1, 1], [1, 0, 1]]
  """
  def flip_vertical(pattern) do
    Enum.reverse(pattern)
  end

  @doc """
      iex> Day21.Rule.flip_horizontal([[1, 0, 1], [1, 1, 1], [0, 1, 1]])
      [[1, 0, 1], [1, 1, 1], [1, 1, 0]]
  """
  def flip_horizontal(pattern) do
    Enum.map(pattern, &Enum.reverse/1)
  end

  @doc """
      iex> Day21.Rule.rotate_cw([[1, 0, 1], [1, 1, 0], [0, 1, 1]])
      [[0, 1, 1], [1, 1, 0], [1, 0, 1]]

      iex> Day21.Rule.rotate_cw([[1, 0, 1], [1, 1, 0], [0, 1, 1]], 4)
      [[1, 0, 1], [1, 1, 0], [0, 1, 1]]
  """
  def rotate_cw(pattern) do
    rotate_cw(pattern, 1)
  end

  def rotate_cw(pattern, 0) do
    pattern
  end

  def rotate_cw(pattern, times) do
    pattern
      |> List.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.reverse/1)
      |> rotate_cw(times - 1)
  end
end
