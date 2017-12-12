defmodule Day12.Graph do
  def read(filepath) do
    filepath
      |> File.stream!
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list
      |> Enum.reduce(%{}, fn (input, acc) -> add_edge(acc, input) end)
      |> find_nodes_connected_with(0)
      |> length
  end

  @doc """
      iex> %{} |>
      iex> Day12.Graph.add_edge("0 <-> 2") |>
      iex> Day12.Graph.add_edge("1 <-> 1") |>
      iex> Day12.Graph.add_edge("2 <-> 0, 3, 4") |>
      iex> Day12.Graph.add_edge("3 <-> 2, 4") |>
      iex> Day12.Graph.add_edge("4 <-> 2, 3, 6") |>
      iex> Day12.Graph.add_edge("5 <-> 6") |>
      iex> Day12.Graph.add_edge("6 <-> 4, 5") |>
      iex> Day12.Graph.find_nodes_connected_with(0) |>
      iex> Enum.sort
      [0, 2, 3, 4, 5, 6]
  """
  def find_nodes_connected_with(graph, edge, found \\ []) do
    neighbours = graph
      |> Map.fetch!(edge)
      |> MapSet.to_list
    neighbours
      |> Enum.reduce(found, fn (edge, acc) -> if edge in acc, do: acc, else: find_nodes_connected_with(graph, edge, [edge | acc]) end)
      |> Enum.uniq
  end

  @doc """
      iex> graph = Day12.Graph.add_edge(%{}, "0 <-> 2")
      %{0 => MapSet.new([2]), 2 => MapSet.new([0])}
      iex> Day12.Graph.add_edge(graph, "2 <-> 0, 3, 4")
      %{0 => MapSet.new([2]), 2 => MapSet.new([0, 3, 4]), 3 => MapSet.new([2]), 4 => MapSet.new([2])}
  """
  def add_edge(graph, {from, to}) do
    graph
      |> Map.update(from, MapSet.new([to]), &(MapSet.put(&1, to)))
      |> Map.update(to, MapSet.new([from]), &(MapSet.put(&1, from)))
  end

  def add_edge(graph, input) do
    input
      |> parse
      |> Enum.reduce(graph, fn (edge, acc) -> add_edge(acc, edge) end)
  end

  @doc """
      iex> Day12.Graph.parse("0 <-> 2")
      [{0, 2}]
      iex> Day12.Graph.parse("2 <-> 0, 3, 4")
      [{2, 0}, {2, 3}, {2, 4}]
  """
  def parse([_, from, to]) do
    to
      |> String.split(", ")
      |> Enum.map(&({String.to_integer(from), String.to_integer(&1)}))
  end

  def parse(input) do
    Regex.run(~r/(\d+) <-> ([\d, ]+)/, input) |> parse
  end
end
