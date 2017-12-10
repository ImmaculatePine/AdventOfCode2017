defmodule Day7.Tower do
  alias Day7.Tower
  alias Day7.Program

  def new do
    %{}
  end

  def new(filepath) do
    File.stream!(filepath) 
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list
      |> Enum.reduce(Tower.new, fn (line, tower) -> Tower.put(tower, line) end)
      |> Tower.build_dependencies
      |> Tower.calculate_depths
      |> Tower.calculate_weights
  end

  @doc """
      iex> Day7.Tower.new |>
      iex> Day7.Tower.put("aaa (1) -> bbb, ddd") |>
      iex> Day7.Tower.put("bbb (1) -> ccc") |>
      iex> Day7.Tower.put("ccc (1)") |>
      iex> Day7.Tower.put("ddd (1)") |>
      iex> Day7.Tower.build_dependencies |>
      iex> Day7.Tower.root
      {"aaa", %Day7.Program{name: "aaa", weight: 1, parent: nil, children: ["bbb", "ddd"]}}
  """
  def root(tower) do
    Enum.find(tower, fn {_, program} -> program.parent == nil end)
  end

  def fix_error(tower) do
    unbalanced_program = find_last_unbalanced_program(tower)
    potential_unbalancers = children_for(tower, unbalanced_program)
    {unbalancer, diff} = find_unbalancer(potential_unbalancers)
    unbalancer.weight + diff
  end

  @doc """
      iex> Day7.Tower.new |> Day7.Tower.put("pbga (66)")
      %{"pbga" => %Day7.Program{name: "pbga", weight: 66, parent: nil, children: []}}
  """
  def put(tower, input) when is_binary(input) do
    put(tower, Program.parse(input))
  end

  def put(tower, program = %Program{}) do
    Map.put(tower, program.name, program)
  end

  @doc """
  Returns an updated tower with linked parent and child programs

      iex> tower = Day7.Tower.new |> Day7.Tower.put("aaa (66)") |> Day7.Tower.put("bbb (77)")
      iex> Day7.Tower.link(tower, "aaa", "bbb")
      %{
        "aaa" => %Day7.Program{name: "aaa", weight: 66, parent: nil, children: []},
        "bbb" => %Day7.Program{name: "bbb", weight: 77, parent: "aaa", children: []}
      }
      iex> Day7.Tower.link(tower, "aaa", "ccc")
      %{
        "aaa" => %Day7.Program{name: "aaa", weight: 66, parent: nil, children: []},
        "bbb" => %Day7.Program{name: "bbb", weight: 77, parent: nil, children: []}
      }
  """
  def link(tower, parent_name, child_name) do
    case Map.fetch(tower, child_name) do
      {:ok, child} -> Map.put(tower, child_name, Program.link(child, parent_name))
      :error -> tower
    end
  end

  @doc """
      iex> Day7.Tower.new |>
      iex> Day7.Tower.put("aaa (1) -> bbb, ddd") |>
      iex> Day7.Tower.put("bbb (1) -> ccc") |>
      iex> Day7.Tower.put("ccc (1)") |>
      iex> Day7.Tower.put("ddd (1)") |>
      iex> Day7.Tower.build_dependencies
      %{
        "aaa" => %Day7.Program{name: "aaa", weight: 1, parent: nil, children: ["bbb", "ddd"]},
        "bbb" => %Day7.Program{name: "bbb", weight: 1, parent: "aaa", children: ["ccc"]},
        "ccc" => %Day7.Program{name: "ccc", weight: 1, parent: "bbb", children: []},
        "ddd" => %Day7.Program{name: "ddd", weight: 1, parent: "aaa", children: []}
      }
  """
  def build_dependencies(tower) do
    Enum.reduce(tower, tower, fn ({name, program}, acc) ->
      Enum.reduce(program.children, acc, fn (child, sub_acc) -> link(sub_acc, name, child) end)
    end)
  end

  @doc """
      iex> Day7.Tower.new |>
      iex> Day7.Tower.put("aaa (1) -> bbb, ddd") |>
      iex> Day7.Tower.put("bbb (1) -> ccc") |>
      iex> Day7.Tower.put("ccc (1)") |>
      iex> Day7.Tower.put("ddd (1)") |>
      iex> Day7.Tower.build_dependencies |>
      iex> Day7.Tower.calculate_depths
      %{
        "aaa" => %Day7.Program{name: "aaa", weight: 1, depth: 0, parent: nil, children: ["bbb", "ddd"]},
        "bbb" => %Day7.Program{name: "bbb", weight: 1, depth: 1, parent: "aaa", children: ["ccc"]},
        "ccc" => %Day7.Program{name: "ccc", weight: 1, depth: 2, parent: "bbb", children: []},
        "ddd" => %Day7.Program{name: "ddd", weight: 1, depth: 1, parent: "aaa", children: []}
      }
  """
  def calculate_depths(tower) do
    tower
    |> Enum.map(fn {name, program} -> {name, %Program{program | depth: calculate_depth(tower, program)}} end)
    |> Map.new
  end

  defp calculate_depth(_tower, %Program{parent: nil}) do
    0
  end

  defp calculate_depth(tower, %Program{parent: parent}) do
    calculate_depth(tower, Map.fetch!(tower, parent)) + 1
  end

  @doc """
      iex> alias Day7.Tower
      iex> Tower.new |>
      iex> Tower.put("pbga (66)") |>
      iex> Tower.put("xhth (57)") |>
      iex> Tower.put("ebii (61)") |>
      iex> Tower.put("havc (66)") |>
      iex> Tower.put("ktlj (57)") |>
      iex> Tower.put("fwft (72) -> ktlj, cntj, xhth") |>
      iex> Tower.put("qoyq (66)") |>
      iex> Tower.put("padx (45) -> pbga, havc, qoyq") |>
      iex> Tower.put("tknk (41) -> ugml, padx, fwft") |>
      iex> Tower.put("jptl (61)") |>
      iex> Tower.put("ugml (68) -> gyxo, ebii, jptl") |>
      iex> Tower.put("gyxo (61)") |>
      iex> Tower.put("cntj (57)") |>
      iex> Tower.build_dependencies |>
      iex> Tower.calculate_weights
      %{
        "tknk" => %Day7.Program{name: "tknk", weight: 41, tower_weight: 778, parent: nil,    children: ["ugml", "padx", "fwft"]},
        "ugml" => %Day7.Program{name: "ugml", weight: 68, tower_weight: 251, parent: "tknk", children: ["gyxo", "ebii", "jptl"]},
        "padx" => %Day7.Program{name: "padx", weight: 45, tower_weight: 243, parent: "tknk", children: ["pbga", "havc", "qoyq"]},
        "fwft" => %Day7.Program{name: "fwft", weight: 72, tower_weight: 243, parent: "tknk", children: ["ktlj", "cntj", "xhth"]},
        "gyxo" => %Day7.Program{name: "gyxo", weight: 61, tower_weight: 61, parent: "ugml", children: []},
        "ebii" => %Day7.Program{name: "ebii", weight: 61, tower_weight: 61, parent: "ugml", children: []},
        "jptl" => %Day7.Program{name: "jptl", weight: 61, tower_weight: 61, parent: "ugml", children: []},
        "pbga" => %Day7.Program{name: "pbga", weight: 66, tower_weight: 66, parent: "padx", children: []},
        "havc" => %Day7.Program{name: "havc", weight: 66, tower_weight: 66, parent: "padx", children: []},
        "qoyq" => %Day7.Program{name: "qoyq", weight: 66, tower_weight: 66, parent: "padx", children: []},
        "ktlj" => %Day7.Program{name: "ktlj", weight: 57, tower_weight: 57, parent: "fwft", children: []},
        "cntj" => %Day7.Program{name: "cntj", weight: 57, tower_weight: 57, parent: "fwft", children: []},
        "xhth" => %Day7.Program{name: "xhth", weight: 57, tower_weight: 57, parent: "fwft", children: []}
      }
  """
  def calculate_weights(tower) do
    Enum.map(tower, fn
      {name, program} -> {name, %{program | tower_weight: calculate_tower_weight(tower, program)}}
    end) |> Map.new
  end

  defp calculate_tower_weight(tower, program = %Program{children: children}) do
    fun = fn child_name ->
      calculate_tower_weight(tower, Map.fetch!(tower, child_name))
    end
    program.weight + (children |> Enum.map(fun) |> Enum.sum)
  end

  @doc """
      iex> alias Day7.Tower
      iex> Tower.new |>
      iex> Tower.put("pbga (66)") |>
      iex> Tower.put("xhth (57)") |>
      iex> Tower.put("ebii (61)") |>
      iex> Tower.put("havc (66)") |>
      iex> Tower.put("ktlj (57)") |>
      iex> Tower.put("fwft (72) -> ktlj, cntj, xhth") |>
      iex> Tower.put("qoyq (66)") |>
      iex> Tower.put("padx (45) -> pbga, havc, qoyq") |>
      iex> Tower.put("tknk (41) -> ugml, padx, fwft") |>
      iex> Tower.put("jptl (61)") |>
      iex> Tower.put("ugml (68) -> gyxo, ebii, jptl") |>
      iex> Tower.put("gyxo (61)") |>
      iex> Tower.put("cntj (57)") |>
      iex> Tower.build_dependencies |>
      iex> Tower.calculate_weights |>
      iex> Tower.find_unbalanced_programs
      [%Day7.Program{name: "tknk", weight: 41, tower_weight: 778, parent: nil, children: ["ugml", "padx", "fwft"]}]
  """
  def find_unbalanced_programs(tower) do
    tower
      |> Enum.filter(fn {_, program} -> !balanced?(tower, program) end)
      |> Enum.map(fn {_, program} -> program end)
  end

  def find_last_unbalanced_program(tower) do
    tower
      |> find_unbalanced_programs
      |> Enum.max_by(&(&1.depth))
  end

  def children_for(tower, %Program{name: name}) do
    tower
      |> Enum.filter(fn {_, program} -> program.parent == name end)
      |> Enum.map(fn {_, program} -> program end)
  end

  defp find_unbalancer(programs) do
    weights_map = Enum.reduce(programs, %{}, fn program, acc ->
      Map.update(acc, program.tower_weight, 1, &(&1 + 1))
    end)
    {correct_weight, _} = Enum.max_by(weights_map, fn {_,v} -> v end)
    {invalid_weight, _} = Enum.min_by(weights_map, fn {_,v} -> v end)
    unbalancer = Enum.find(programs, fn program -> program.tower_weight == invalid_weight end)
    {
      unbalancer,
      correct_weight - invalid_weight
    }
  end

  def balanced?(tower, program) do
    number_of_weights = program.children
      |> Enum.map(fn name -> Map.fetch!(tower, name).tower_weight end)
      |> Enum.uniq
      |> length
    number_of_weights < 2
  end
end
