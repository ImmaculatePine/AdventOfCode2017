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

  def read_and_dance(data, filepath) do
    dance(data, File.read!(filepath))
  end

  @doc """
      iex> Day16.Dance.dance("abcde", "s1,x3/4,pe/b")
      "baedc"
  """
  def dance(data, movements) when is_binary(movements) do
    movements_list = movements
      |> String.split(",")
      |> Enum.map(&parse/1)
    data
      |> String.split("", trim: true)
      |> dance(movements_list)
      |> Enum.join
  end

  def dance(data, []) do
    data
  end

  def dance(data, [head | tail]) do
    data
      |> move(head)
      |> dance(tail)
  end

  def move(data, movement) do
    case movement do
      {:spin, x} -> spin(data, x)
      {:exchange, x, y} -> exchange(data, x, y)
      {:partner, x, y} -> partner(data, x, y)
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
