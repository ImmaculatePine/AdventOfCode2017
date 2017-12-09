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
  end

  @doc """
      iex> Day7.Tower.new |>
      iex>  Day7.Tower.put("aaa (1) -> bbb, ddd") |>
      iex>  Day7.Tower.put("bbb (1) -> ccc") |>
      iex>  Day7.Tower.put("ccc (1)") |>
      iex>  Day7.Tower.put("ddd (1)") |>
      iex>  Day7.Tower.build_dependencies |>
      iex>  Day7.Tower.root
      {"aaa", %Day7.Program{name: "aaa", weight: 1, parent: nil, children: ["bbb", "ddd"]}}
  """
  def root(tower) do
    Enum.find(tower, fn {_, program} -> program.parent == nil end)
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
      iex>  Day7.Tower.put("aaa (1) -> bbb, ddd") |>
      iex>  Day7.Tower.put("bbb (1) -> ccc") |>
      iex>  Day7.Tower.put("ccc (1)") |>
      iex>  Day7.Tower.put("ddd (1)") |>
      iex>  Day7.Tower.build_dependencies
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
end
