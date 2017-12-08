defmodule Day5.Jump do
  @doc """
      iex> Day5.Jump.run([0, 3, 0, 1, -3])
      5
  """
  def run(instructions) when is_list(instructions) do
    run(instructions, 0, 0)
  end

  def run(filepath) when is_binary(filepath) do
    File.stream!(filepath) 
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list
      |> run
  end

  defp run(instructions, current_position, steps_done) do
    current_instruction = Enum.at(instructions, current_position)
    next_position = current_position + current_instruction
    if next_position >= length(instructions) do
      steps_done + 1
    else
      run(
        List.replace_at(instructions, current_position, current_instruction + 1),
        next_position,
        steps_done + 1
      )
    end
  end
end
