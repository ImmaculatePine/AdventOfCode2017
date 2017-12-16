defmodule Day16.Dance do
  def parse([_, "s", x]), do: {:spin, String.to_integer(x)}
  def parse([_, "x", x, _, y]), do: {:exchange, String.to_integer(x), String.to_integer(y)}
  def parse([_, "p", x, _, y]), do: {:partner, x, y}

  @doc """
      iex> Day16.Dance.parse("s10")
      {:spin, 10}
      iex> Day16.Dance.parse("x1/15")
      {:exchange, 1, 15}
      iex> Day16.Dance.parse("pa/c")
      {:partner, "a", "c"}
  """
  def parse(movement) do
    ~r/(s|x|p)([a-z0-9]+)(\/([a-z0-9]+))?/
      |> Regex.run(movement)
      |> parse
  end

  def read_and_dance(data, filepath, times \\ 1) do
    dance(data, File.read!(filepath), times)
  end

  @doc """
      iex> Day16.Dance.dance("abcde", "s1,x3/4,pe/b", 1)
      "baedc"
      iex> Day16.Dance.dance("abcde", "s1,x3/4,pe/b", 2)
      "ceadb"
      iex> Day16.Dance.dance("abcde", "s1,x3/4,pe/b", 10)
      "ceadb"
  """
  def dance(data, movements, times) when is_binary(data) and is_binary(movements) do
    movements_list = movements
      |> String.split(",")
      |> Enum.map(&parse/1)
    data_list = String.split(data, "", trim: true)
    cycles = cycles(data_list, movements_list)
    data_list
      |> dance(movements_list, rem(times, cycles))
      |> Enum.join
  end

  def dance(list, movements, times) when is_list(list) and is_list(movements) do
    dance(list, movements, movements, times)
  end

  @doc """
  Calculates how many cycles of dance should be repeated to get the same combination again

      iex> list = ["a", "b", "c", "d", "e"]
      iex> movements = "s1,x3/4,pe/b" |> String.split(",") |> Enum.map(&Day16.Dance.parse/1)
      iex> Day16.Dance.cycles(list, movements)
      4
  """
  def cycles(list, movements) do
    cycles(list, list, movements, 0)
  end

  defp cycles(original_list, original_list, _movements, counter) when counter > 0 do
    counter
  end

  defp cycles(list, original_list, movements, counter) do
    list
      |> dance(movements, 1)
      |> cycles(original_list, movements, counter + 1)
  end

  def dance(list, _movements, _all_movements, 0) do
    list
  end

  def dance(list, [], all_movements, times) do
    dance(list, all_movements, all_movements, times - 1)
  end

  def dance(list, [head | tail], all_movements, times) do
    list
      |> move(head)
      |> dance(tail, all_movements, times)
  end

  def move(list, movement) do
    case movement do
      {:spin, x} -> spin(list, x)
      {:exchange, x, y} -> exchange(list, x, y)
      {:partner, x, y} -> partner(list, x, y)
    end
  end

  def spin(list, 0) do
    list
  end

  @doc """
      iex> Day16.Dance.spin(["a", "b", "c", "d", "e"], 3)
      ["c", "d", "e", "a", "b"]
  """
  def spin(list, x) do
    [head | tail] = Enum.reverse(list)
    spin([head | Enum.reverse(tail)], x - 1)
  end

  @doc """
      iex> Day16.Dance.exchange(["a", "b", "c", "d", "e"], 3, 4)
      ["a", "b", "c", "e", "d"]
  """
  def exchange(list, x, y) do
    a = Enum.at(list, x)
    b = Enum.at(list, y)
    list
      |> List.replace_at(x, b)
      |> List.replace_at(y, a)
  end

  @doc """
      iex> Day16.Dance.partner(["a", "b", "c", "d", "e"], "a", "c")
      ["c", "b", "a", "d", "e"]
  """
  def partner(list, a, b) do
    x = Enum.find_index(list, &(&1 == a))
    y = Enum.find_index(list, &(&1 == b))
    list
      |> List.replace_at(x, b)
      |> List.replace_at(y, a)
  end
end
