defmodule Day18.Registry do
  @doc """
      iex> Day18.Registry.read(%{a: 100}, :a)
      100
      iex> Day18.Registry.read(%{a: 100}, :b)
      0
  """
  def read(registry, register) do
    case Map.fetch(registry, register) do
      {:ok, value} -> value
      :error -> 0
    end
  end

  @doc """
      iex> Day18.Registry.write(%{}, :a, 100)
      %{a: 100}
      iex> Day18.Registry.write(%{a: 100}, :a, 150)
      %{a: 150}
  """
  def write(registry, register, value) do
    Map.put(registry, register, value)
  end

  @doc """
      iex> Day18.Registry.read_meta(%{}, :test)
      nil
      iex> Day18.Registry.read_meta(%{meta: %{}}, :test)
      nil
      iex> Day18.Registry.read_meta(%{meta: %{test: :works}}, :test)
      :works
  """
  def read_meta(registry, key) do
    case Map.fetch(registry, :meta) do
      {:ok, meta} -> meta[key]
      :error -> nil
    end
  end

  @doc """
      iex> Day18.Registry.write_meta(%{}, :test, 1)
      %{meta: %{test: 1}}
      iex> Day18.Registry.write_meta(%{meta: %{test: 1}}, :test, 2)
      %{meta: %{test: 2}}
  """
  def write_meta(registry, key, value) do
    case Map.fetch(registry, :meta) do
      {:ok, meta} -> %{registry | meta: Map.put(meta, key, value)}
      :error -> Map.put(registry, :meta, %{key => value})
    end
  end

  def recover(instructions) do
    instructions
      |> run
      |> read_meta(:last_played_frequency)
  end

  @doc """
      iex> ["set a 1" , "add a 2", "mul a a", "mod a 5", "snd a", "set a 0", "rcv a", "jgz a -1", "set a 1", "jgz a -2"] |>
      iex> Day18.Registry.run
      %{a: 1, meta: %{last_played_frequency: 4}}
  """
  def run(instructions) when is_list(instructions) do
    run(%{meta: %{}}, Enum.map(instructions, &Day18.Op.parse/1), 0)
  end

  def run(registry, instructions, current_index) when is_list(instructions) do
    case Enum.at(instructions, current_index) do
      {:rcv, value} ->
        if get(registry, value) == 0, do: run(registry, instructions, current_index + 1), else: registry
      {:jgz, register, value} ->
        run(registry, instructions, current_index + (if get(registry, register) > 0, do: get(registry, value), else: 1))
      instruction ->
        registry |> run(instruction) |> run(instructions, current_index + 1)
    end
  end

  def run(registry, instruction) when is_binary(instruction) do
    run(registry, Day18.Op.parse(instruction))
  end

  def run(registry, {:snd, value}) do
    write_meta(registry, :last_played_frequency, get(registry, value))
  end

  def run(registry, {:set, register, value}) do
    write(registry, register, get(registry, value))
  end

  def run(registry, {:add, register, value}) do
    old_value = read(registry, register)
    write(registry, register, old_value + get(registry, value))
  end

  def run(registry, {:mul, register, value}) do
    old_value = read(registry, register)
    write(registry, register, old_value * get(registry, value))
  end

  def run(registry, {:mod, register, value}) do
    old_value = read(registry, register)
    write(registry, register, rem(old_value, get(registry, value)))
  end

  def get(_, value) when is_integer(value), do: value
  def get(registry, register) when is_atom(register), do: read(registry, register)
end
