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
      %{0 => {3, 0, 4}, 1 => {2, 0, 2}, 4 => {4, 0, 6}}
  """
  def add_layer(firewall, input) when is_binary(input) do
    add_layer(firewall, Regex.run(~r/(\d+): (\d+)/, input))
  end

  def add_layer(firewall, [_, layer, depth]) do
    Map.put(firewall, String.to_integer(layer), build_layer(depth))
  end

  def build_layer(depth) when is_binary(depth) do
    depth |> String.to_integer |> build_layer
  end

  def build_layer(depth) when is_integer(depth) do
    {depth, 0, 2 * (depth - 1)}
  end

  @doc """
  Generates the whole run through the firewall in time.
  First scanner's position is shown at 0psec of time, second's at 1psec and so on.

      iex> firewall = %{0 => {3, 0, 4}, 1 => {2, 0, 2}, 4 => {4, 0, 6}}
      iex> Day13.Firewall.run_in_time(firewall, 0)
      %{0 => {3, 0, 4}, 1 => {2, 1, 2}, 4 => {4, 2, 6}}
      iex> Day13.Firewall.run_in_time(firewall, 1)
      %{0 => {3, 1, 4}, 1 => {2, 0, 2}, 4 => {4, 1, 6}}
  """
  def run_in_time(firewall, delay) do
    firewall
     |> Enum.map(fn {layer, scanner} -> {layer, scanner_in_time(scanner, delay + layer)} end)
     |> Map.new
  end

  @doc """
  Generates a new scanner position in the specified moment of time

      iex> Day13.Firewall.scanner_in_time({3, 0, 4}, 0)
      {3, 0, 4}
      iex> Day13.Firewall.scanner_in_time({3, 0, 4}, 1)
      {3, 1, 4}
      iex> Day13.Firewall.scanner_in_time({3, 0, 4}, 10)
      {3, 2, 4}
  """
  def scanner_in_time({depth, _, period}, time) do
    offset = rem(time, period)
    if offset > depth - 1 do
      {depth, period - offset, period}
    else
      {depth, offset, period}
    end
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
      |> run_in_time(0)
      |> Enum.filter(fn {_, {_, position, _}} -> position == 0 end)
      |> Enum.reduce(0, fn ({layer, {depth, _, _}}, acc) -> acc + layer * depth end)
  end

  @doc """
      iex> %{} |>
      iex> Day13.Firewall.add_layer("0: 3") |>
      iex> Day13.Firewall.add_layer("1: 2") |>
      iex> Day13.Firewall.add_layer("4: 4") |>
      iex> Day13.Firewall.add_layer("6: 4") |>
      iex> Day13.Firewall.safe_delay
      10
  """
  def safe_delay(firewall) do
    safe_delay(firewall, 0)
  end

  def safe_delay(firewall, delay) do
    caught = firewall
      |> run_in_time(delay)
      |> Enum.any?(fn {_, {_, position, _}} -> position == 0 end)
    if caught do
      safe_delay(firewall, delay + 1)
    else
      delay
    end
  end
end
