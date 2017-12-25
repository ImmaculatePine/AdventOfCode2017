defmodule Day25.Machine do
  def run(machine) do
    run(machine, %{}, 0)
  end

  defp run({_state, 0, _rules}, tape, _cursor) do
    tape
  end

  defp run({state, steps_count, rules}, tape, cursor) do
    {new_value, direction, new_state} = rules[state][read(tape, cursor)]
    run(
      {new_state, steps_count - 1, rules},
      Map.put(tape, cursor, new_value),
      move(cursor, direction)
    )
  end

  defp move(cursor, direction) do
    case direction do
      :left -> cursor - 1
      :right -> cursor + 1
    end
  end

  defp read(tape, cursor) do
    case Map.fetch(tape, cursor) do
      {:ok, value} -> value
      :error -> 0
    end
  end

  def checksum(tape) do
    tape
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sum
  end
end
