defmodule Day18.Duet do
  alias Day18.Program

  @doc """
      iex> {p0, p1} = Day18.Duet.start(["snd 1", "snd 2", "snd p", "rcv a", "rcv b", "rcv c", "rcv d"])
      iex> p0.registry
      %{p: 0, a: 1, b: 2, c: 1}
      iex> p1.registry
      %{p: 1, a: 1, b: 2, c: 0}
  """
  def start(instructions) do
    parsed_instructions = Enum.map(instructions, &Day18.Op.parse/1)
    {current, other} = run(
      Program.new(0, parsed_instructions),
      Program.new(1, parsed_instructions)
    )
    if current.id == 0, do: {current, other}, else: {other, current}
  end

  def run(current, other) do
    current = %Program{sent_messages: sent_messages} = Program.run(current)
    other = Program.push_received_messages(other, sent_messages)

    if Program.terminated?(current) && Program.terminated?(other) do
      {current, other}
    else
      run(Program.ok(other), Program.clear_sent_messages(current))
    end
  end
end
