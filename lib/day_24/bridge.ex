defmodule Day24.Bridge do
  @doc """
      iex> components = [[0, 2], [2, 2], [2, 3], [3, 4], [3, 5], [0, 1], [10, 1], [9, 10]]
      iex> Day24.Bridge.generate(components, &Day24.Bridge.stronger?/2)
      [9, 10, 10, 1, 1, 0, 0]
      iex> Day24.Bridge.generate(components, &Day24.Bridge.longer_or_stronger?/2)
      [5, 3, 3, 2, 2, 2, 2, 0, 0]
  """
  def generate(components, sorter) do
    generate([0], components, sorter)
  end

  def generate(bridge, components, sorter) do
    connector = hd(bridge)
    components
      |> Enum.filter(&(connector in &1))
      |> Enum.map(fn component ->
        next_connector = component |> List.delete(connector) |> hd
        other_components = List.delete(components, component)
        generate([next_connector, connector], other_components, sorter)
      end)
      |> Enum.sort(sorter)
      |> List.last
      |> Kernel.||([])
      |> Enum.concat(bridge)
  end

  def strength(bridge), do: Enum.sum(bridge)
  def stronger?(a, b), do: strength(a) <= strength(b)
  def longer_or_stronger?(a, b) when length(a) == length(b), do: stronger?(a, b)
  def longer_or_stronger?(a, b), do: length(a) <= length(b)
end
