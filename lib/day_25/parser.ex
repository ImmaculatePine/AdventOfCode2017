defmodule Day25.Parser do
  @doc """
      iex> {initial_state, steps_count, rules} = File.read!("scripts/inputs/day_25.txt") |> Day25.Parser.parse
      iex> initial_state
      :A
      iex> steps_count
      12302209
      iex> Map.keys(rules)
      [:A, :B, :C, :D, :E, :F]
      iex> rules[:A]
      %{0 => {1, :right, :B}, 1 => {0, :left, :D}}
  """
  def parse(input) when is_binary(input) do
    ~r"""
    Begin in state ([A-Z])\.
    Perform a diagnostic checksum after (\d+) steps.

    (.+)
    """s
      |> Regex.run("#{input}\n")
      |> parse
  end

  def parse([_, initial_state, steps_count, rules]) do
    {
      String.to_atom(initial_state),
      String.to_integer(steps_count),
      parse_rules(rules)
    }
  end

  defp parse_rules(input) do
    input
      |> String.split("\n\n")
      |> Enum.map(&parse_rule/1)
      |> Map.new
  end

  defp parse_rule(input) when is_binary(input) do
    ~r"""
    In state ([A-Z]):
      If the current value is 0:
        - Write the value (\d)\.
        - Move one slot to the (right|left)\.
        - Continue with state ([A-Z])\.
      If the current value is 1:
        - Write the value (\d)\.
        - Move one slot to the (right|left)\.
        - Continue with state ([A-Z])\.
    """
      |> Regex.run("#{input}\n")
      |> parse_rule
  end

  defp parse_rule([_, state, cond_0_value, cond_0_direction, cond_0_next_state, cond_1_value, cond_1_direction, cond_1_next_state]) do
    {
      String.to_atom(state),
      %{
        0 => {String.to_integer(cond_0_value), String.to_atom(cond_0_direction), String.to_atom(cond_0_next_state)},
        1 => {String.to_integer(cond_1_value), String.to_atom(cond_1_direction), String.to_atom(cond_1_next_state)}  
      }
    }
  end
end
