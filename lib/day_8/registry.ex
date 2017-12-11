defmodule Day8.Registry do
  def run(filepath) do
    File.stream!(filepath) 
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list
      |> Enum.reduce(%{}, fn (line, registry) -> run(registry, line) end)
  end

  @doc """
      iex> Day8.Registry.max(%{a: 10, b: 20, c: 30})
      {:c, 30}
  """
  def max(registry) do
    Enum.max_by(registry, fn {_, v} -> v end)
  end

  @doc """
      iex> Day8.Registry.run(%{a: 100}, "a inc 100 if b > 0")
      %{a: 100}
      iex> Day8.Registry.run(%{a: 100}, "a inc 100 if b == 0")
      %{a: 200}
  """
  def run(registry, instruction) when is_binary(instruction) do
    run(registry, Day8.Op.parse(instruction))
  end

  def run(registry, operation = %Day8.Op{condition: condition}) do
    if condition?(registry, condition) do
      execute(registry, operation)
    else
      registry
    end
  end

  @doc """
      iex> Day8.Registry.execute(%{a: 100}, Day8.Op.parse("a inc 100 if b >= 0"))
      %{a: 200}
      iex> Day8.Registry.execute(%{a: 100}, Day8.Op.parse("b dec 50 if c == 10"))
      %{a: 100, b: -50}
  """
  def execute(registry, %Day8.Op{register: register, action: action, diff: diff}) do
    old_value = read(registry, register)
    new_value = case action do
      :inc -> old_value + diff
      :dec -> old_value - diff
    end
    write(registry, register, new_value)
  end

  @doc """
      iex> Day8.Registry.read(%{a: 100}, :a)
      100
      iex> Day8.Registry.read(%{a: 100}, :b)
      0
  """
  def read(registry, register) do
    case Map.fetch(registry, register) do
      {:ok, value} -> value
      :error -> 0
    end
  end

  @doc """
      iex> Day8.Registry.write(%{}, :a, 100)
      %{a: 100}
      iex> Day8.Registry.write(%{a: 100}, :a, 150)
      %{a: 150}
  """
  def write(registry, register, value) do
    Map.put(registry, register, value)
  end

  @doc """
      iex> registry = %{a: 100}
      iex> Day8.Registry.condition?(registry, {:>, :a, 50})
      true
      iex> Day8.Registry.condition?(registry, {:>=, :a, 101})
      false
      iex> Day8.Registry.condition?(registry, {:<, :b, 50})
      true
      iex> Day8.Registry.condition?(registry, {:<=, :b, 0})
      true
      iex> Day8.Registry.condition?(registry, {:==, :a, 150})
      false
      iex> Day8.Registry.condition?(registry, {:!=, :a, 150})
      true
  """
  def condition?(registry, {operator, register, value}) do
    register_value = read(registry, register)
    case operator do
      :> -> register_value > value
      :>= -> register_value >= value
      :< -> register_value < value
      :<= -> register_value <= value
      :== -> register_value == value
      :!= -> register_value != value
    end
  end
end
