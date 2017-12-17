defmodule Day17.Buffer do
  def value_after(n, step_size) do
    {buffer, current_position} = build(n, step_size)
    Enum.at(buffer, current_position + 1)
  end

  def value_after_0(total_buffer_size, step_size) do
    emulate_build(total_buffer_size, step_size)
  end

  @doc """
  Builds the whole buffer and returns a tuple with {buffer, current_position}

      iex> Day17.Buffer.build(9, 3)
      {[0, 9, 5, 7, 2, 4, 3, 8, 6, 1], 1}
  """
  def build(inserts_count, step_size) do
    build(inserts_count, step_size, 1, 0, [0])
  end

  defp build(0, _step_size, _new_number, current_position, buffer) do
    {buffer, current_position}
  end

  defp build(inserts_count, step_size, new_number, current_position, buffer) do
    new_position = new_position(current_position, length(buffer), step_size)
    build(
      inserts_count - 1,
      step_size,
      new_number + 1,
      new_position,
      List.insert_at(buffer, new_position, new_number)
    )
  end

  @doc """
  Emulates building the whole buffer of n elements and returns a value after the 0's element (with index == 1)

      iex> Day17.Buffer.emulate_build(9, 3)
      9
  """
  def emulate_build(n, step_size) do
    emulate_build(n, step_size, 1, 0, 1, nil)
  end

  defp emulate_build(0, _step_size, _new_number, _current_position, _buffer_length, last_inserted_value) do
    last_inserted_value
  end

  defp emulate_build(n, step_size, new_number, current_position, buffer_length, last_inserted_value) do
    new_position = new_position(current_position, buffer_length, step_size)
    emulate_build(
      n - 1,
      step_size,
      new_number + 1,
      new_position,
      buffer_length + 1,
      (if new_position == 1, do: new_number, else: last_inserted_value)
    )
  end

  @doc """
      iex> Day17.Buffer.new_position(0, 1, 3)
      1
      iex> Day17.Buffer.new_position(1, 2, 3)
      1
      iex> Day17.Buffer.new_position(1, 3, 3)
      2
  """
  def new_position(current_position, buffer_length, step_size) do
    rem(current_position + step_size, buffer_length) + 1
  end
end
