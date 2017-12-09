defmodule Day7.Program do
  defstruct name: nil, weight: nil, parent: nil, children: []

  def new(name, weight, children \\ []) do
    %Day7.Program{
      name: name,
      weight: String.to_integer(weight),
      children: children
    }
  end

  @doc """
      iex> Day7.Program.parse("pbga (66)")
      %Day7.Program{name: "pbga", weight: 66, parent: nil, children: []}

      iex> Day7.Program.parse("fwft (72) -> ktlj, cntj, xhth")
      %Day7.Program{name: "fwft", weight: 72, parent: nil, children: ["ktlj", "cntj", "xhth"]}
  """
  def parse(string) when is_binary(string) do
    parse(Regex.run(~r/\A(.+) \((\d+)\)( -> (.+))?\Z/, string))
  end

  def parse([_, name, weight, _, children]) do
    Day7.Program.new(name, weight, String.split(children, ", "))
  end

  def parse([_, name, weight]) do
    Day7.Program.new(name, weight)
  end

  @doc """
      iex> Day7.Program.new("a", "100") |> Day7.Program.link("b")
      %Day7.Program{name: "a", weight: 100, parent: "b", children: []}
  """
  def link(program, parent) do
    %{program | parent: parent}
  end
end
