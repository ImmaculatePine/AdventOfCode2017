defmodule Day12.Graph do
  def read(filepath) do
    filepath
      |> File.stream!
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list
      |> Enum.reduce(%{}, fn (input, acc) -> add_edge(acc, input) end)
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
      iex> Day12.Graph.count_of_connected_edges(0)
      6
  """
  def count_of_connected_edges(graph, edge) do
    graph |> traverse(edge) |> length
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
      iex> Day12.Graph.number_of_disconnected_groups
      2
  """
  def number_of_disconnected_groups(graph) do
    number_of_disconnected_groups(graph, 0, Map.keys(graph), [])
  end

  defp number_of_disconnected_groups(_graph, counter, [], _traversed) do
    counter
  end

  defp number_of_disconnected_groups(graph, counter, [head | tail], traversed) do
    if head in traversed do
      number_of_disconnected_groups(graph, counter, tail, traversed)
    else
      number_of_disconnected_groups(graph, counter + 1, tail, traversed ++ traverse(graph, head))
    end
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
      iex> Day12.Graph.traverse(0) |>
      iex> Enum.sort
      [0, 2, 3, 4, 5, 6]
  """
  def traverse(graph, start_edge, traversed \\ []) do
    graph
      |> Map.fetch!(start_edge)
      |> MapSet.to_list
      |> Enum.reduce(traversed, fn (edge, acc) -> if edge in acc, do: acc, else: traverse(graph, edge, [edge | acc]) end)
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
