defmodule Day6.MemoryReallocation do
  def run(filepath) when is_binary(filepath) do
    File.read!(filepath)
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> run
  end

  @doc """
      iex> Day6.MemoryReallocation.run([0, 2, 7, 0])
      {5, 4}
  """
  def run(banks) when is_list(banks) do
    run(banks, [[banks]])
  end

  defp run(banks, stack) do
    reallocated_banks = reallocate(banks)
    if reallocated_banks in stack do
      stack_size = length(stack)
      infinite_loop_start = stack |> Enum.reverse |> Enum.find_index(&(&1 == reallocated_banks))
      {stack_size, stack_size - infinite_loop_start}
    else
      run(reallocated_banks, [reallocated_banks | stack])
    end
  end

  @doc """
  Finds the memory bank with the most blocks and redistributes those blocks among the banks.

      iex> Day6.MemoryReallocation.reallocate([0, 2, 7, 0])
      [2, 4, 1, 2]
      iex> Day6.MemoryReallocation.reallocate([2, 4, 1, 2])
      [3, 1, 2, 3]
      iex> Day6.MemoryReallocation.reallocate([3, 1, 2, 3])
      [0, 2, 3, 4]
  """
  def reallocate(banks) do
    {value, index} = most_loaded_bank(banks)
    distribute(
      List.replace_at(banks, index, 0),
      value,
      index + 1
    )
  end

  @doc """
  Finds a bank with the highest load and return its value and index

      iex> Day6.MemoryReallocation.most_loaded_bank([0, 2, 7, 0])
      {7, 2}
      iex> Day6.MemoryReallocation.most_loaded_bank([2, 4, 1, 2])
      {4, 1}
      iex> Day6.MemoryReallocation.most_loaded_bank([3, 1, 2, 3])
      {3, 0}
      iex> Day6.MemoryReallocation.most_loaded_bank([4, 1, 15, 12, 0, 9, 9, 5, 5, 8, 7, 3, 14, 5, 12, 3])
      {15, 2}
  """
  def most_loaded_bank(banks = [head | _]) do
    most_loaded_bank(banks, head, 0, 0)
  end

  defp most_loaded_bank([], max_value, _current_index, max_index) do
    {max_value, max_index}
  end

  defp most_loaded_bank([head | tail], max_value, current_index, max_index) do
    if head > max_value do
      most_loaded_bank(tail, head, current_index + 1, current_index)
    else
      most_loaded_bank(tail, max_value, current_index + 1, max_index)
    end
  end

  @doc """
  Distributes `value` over the `banks` starting from the `index` bank evenly

      iex> Day6.MemoryReallocation.distribute([0, 2, 0, 0], 7, 3)
      [2, 4, 1, 2]
      iex> Day6.MemoryReallocation.distribute([2, 0, 1, 2], 4, 2)
      [3, 1, 2, 3]
  """
  def distribute(banks, 0, _index) do
    banks
  end

  def distribute(banks, value, index) do
    real_index = if index == length(banks), do: 0, else: index
    old_value = Enum.at(banks, real_index)
    new_banks = List.replace_at(banks, real_index, old_value + 1)
    distribute(new_banks, value - 1, real_index + 1)
  end
end
