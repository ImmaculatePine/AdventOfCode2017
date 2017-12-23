defmodule Day23.Registry do
  @doc """
      iex> Day23.Registry.read(%{a: 100}, :a)
      100
      iex> Day23.Registry.read(%{a: 100}, :b)
      0
  """
  def read(registry, register) do
    case Map.fetch(registry, register) do
      {:ok, value} -> value
      :error -> 0
    end
  end

  @doc """
      iex> Day23.Registry.write(%{}, :a, 100)
      %{a: 100}
      iex> Day23.Registry.write(%{a: 100}, :a, 150)
      %{a: 150}
  """
  def write(registry, register, value) do
    Map.put(registry, register, value)
  end

  @doc """
      iex> registry = %{a: 1}
      iex> Day23.Registry.get(registry, 100)
      100
      iex> Day23.Registry.get(registry, :a)
      1
  """
  def get(_, value) when is_integer(value), do: value
  def get(registry, register) when is_atom(register), do: read(registry, register)

  def run(instructions) do
    run(%{}, instructions, 0, %{})
  end

  defp run(registry, instructions, current, counter) when current >= length(instructions) do
    {registry, counter}
  end

  defp run(registry, instructions, current, counter) do
    case Enum.at(instructions, current) do
      {:jnz, a, b} ->
        jump_size = if get(registry, a) == 0, do: 1, else: get(registry, b)
        run(registry, instructions, current + jump_size, increment(counter, :jnz))
      instruction = {name, _, _} ->
        registry |> execute(instruction) |> run(instructions, current + 1, increment(counter, name))
    end
  end

  defp increment(counter, key) do
    case Map.fetch(counter, key) do
      {:ok, value} -> Map.put(counter, key, value + 1)
      :error -> Map.put(counter, key, 1)
    end
  end

  defp execute(registry, {:set, a, b}) do
    write(
      registry, a, get(registry, b)
    )
  end

  defp execute(registry, {:sub, a, b}) do
    write(
      registry, a, read(registry, a) - get(registry, b)
    )
  end

  defp execute(registry, {:mul, a, b}) do
    write(
      registry, a, read(registry, a) * get(registry, b)
    )
  end
end
