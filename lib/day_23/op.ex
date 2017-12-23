defmodule Day23.Op do
  @doc """
      iex> Day23.Op.parse("set a 1")
      {:set, :a, 1}
      iex> Day23.Op.parse("sub a b")
      {:sub, :a, :b}
  """
  def parse(input) when is_binary(input) do
    ~r/(set|sub|mul|jnz) ([a-z]|-?[0-9]+) ?([a-z]|-?[0-9]+)?/
      |> Regex.run(input)
      |> parse
  end

  def parse([_, command, arg]) do
    {String.to_atom(command), transform_arg(arg)}
  end

  def parse([_, command, arg_1, arg_2]) do
    {
      String.to_atom(command),
      transform_arg(arg_1),
      transform_arg(arg_2)
    }
  end

  defp transform_arg(arg) do
    case Integer.parse(arg) do
      {value, ""} -> value
      :error -> String.to_atom(arg)
    end
  end
end
