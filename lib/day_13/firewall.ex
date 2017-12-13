defmodule Day13.Firewall do
  def read(filename) do
    filename
      |> File.stream!
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list
      |> Enum.reduce(%{}, fn (input, firewall) -> add_layer(firewall, input) end)
  end

  @doc """
      iex> %{} |>
      iex> Day13.Firewall.add_layer("0: 3") |>
      iex> Day13.Firewall.add_layer("1: 2") |>
      iex> Day13.Firewall.add_layer("4: 4")
      %{0 => {3, 0, :down}, 1 => {2, 0, :down}, 4 => {4, 0, :down}}
  """
  def add_layer(firewall, input) when is_binary(input) do
    add_layer(firewall, Regex.run(~r/(\d+): (\d+)/, input))
  end

  def add_layer(firewall, [_, layer, depth]) do
    Map.put(firewall, String.to_integer(layer), {String.to_integer(depth), 0, :down})
  end

  @doc """
      iex> %{} |>
      iex> Day13.Firewall.add_layer("0: 3") |>
      iex> Day13.Firewall.add_layer("1: 2") |>
      iex> Day13.Firewall.add_layer("4: 4") |>
      iex> Day13.Firewall.add_layer("6: 4") |>
      iex> Day13.Firewall.severity
      24
  """
  def severity(firewall) do
    firewall
    |> severity(0, [])
    |> Enum.reduce(0, fn (layer, acc) ->
      {depth, _, _} = Map.fetch!(firewall, layer)
      acc + depth * layer
    end)
  end

  defp severity(firewall, current_position, caughts) do
    if current_position <= last_layer(firewall) do
      severity(
        step(firewall),
        current_position + 1,
        (if caught?(firewall, current_position), do: [current_position | caughts], else: caughts)
      )
    else
      Enum.reverse(caughts)
    end
  end

  def last_layer(firewall) do
    firewall
    |> Map.keys
    |> Enum.max
  end

  @doc """
    iex> firewall = %{0 => {3, 1, :up}, 1 => {2, 0, :down}, 4 => {4, 3, :down}}
    iex> Day13.Firewall.caught?(firewall, 0)
    false
    iex> Day13.Firewall.caught?(firewall, 1)
    true
    iex> Day13.Firewall.caught?(firewall, 2)
    false
  """
  def caught?(firewall, position) do
    case Map.fetch(firewall, position) do
      {:ok, {_, scanner_position, _}} -> scanner_position == 0
      :error -> false
    end
  end

  @doc """
      iex> {3, 0, :down} |> Day13.Firewall.step |> Day13.Firewall.step |> Day13.Firewall.step
      {3, 1, :up}
  """
  def step({depth, scanner_position, direction}) do
    case direction do
      :up -> if scanner_position > 0, do: {depth, scanner_position - 1, :up}, else: {depth, scanner_position + 1, :down}
      :down -> if scanner_position < depth - 1, do: {depth, scanner_position + 1, :down}, else: {depth, scanner_position - 1, :up}
    end
  end

  @doc """
      iex> %{} |>
      iex> Day13.Firewall.add_layer("0: 3") |>
      iex> Day13.Firewall.add_layer("1: 2") |>
      iex> Day13.Firewall.add_layer("4: 4") |>
      iex> Day13.Firewall.step |>
      iex> Day13.Firewall.step |>
      iex> Day13.Firewall.step
      %{0 => {3, 1, :up}, 1 => {2, 1, :down}, 4 => {4, 3, :down}}
  """
  def step(firewall) do
    firewall
      |> Enum.map(fn {number, layer} -> {number, step(layer)} end)
      |> Map.new
  end
end
