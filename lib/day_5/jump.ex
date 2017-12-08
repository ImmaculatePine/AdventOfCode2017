defmodule Day5.Jump do
  @doc """
      iex> Day5.Jump.run([0, 3, 0, 1, -3], &Day5.Jump.increment/1)
      5
      iex> Day5.Jump.run([0, 3, 0, 1, -3], &Day5.Jump.custom_increment/1)
      10
  """
  def run(instructions, transformation) when is_list(instructions) do
    run(instructions, transformation, 0, 0)
  end

  def run(filepath, transformation) when is_binary(filepath) do
    File.stream!(filepath) 
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list
      |> run(transformation)
  end

  defp run(instructions, transformation, current_position, steps_done) do
    current_instruction = Enum.at(instructions, current_position)
    next_position = current_position + current_instruction
    if next_position >= length(instructions) do
      steps_done + 1
    else
      run(
        List.replace_at(instructions, current_position, transformation.(current_instruction)),
        transformation,
        next_position,
        steps_done + 1
      )
    end
  end

  def increment(value), do: value + 1
  def custom_increment(value) when value >= 3, do: value - 1
  def custom_increment(value), do: value + 1
end
