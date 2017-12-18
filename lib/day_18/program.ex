defmodule Day18.Program do
  alias Day18.Program
  alias Day18.Registry

  defstruct id: nil, registry: %{}, instructions: [], current_index: 0, sent_counter: 0, sent_messages: [], received_messages: [], status: :ok

  def new(id, instructions) do
    %Program{id: id, registry: %{p: id}, instructions: instructions}
  end

  def waiting?(%Program{status: status}), do: status == :waiting
  def halted?(%Program{status: status}), do: status == :halted
  def has_pending_received_messages?(%Program{received_messages: received_messages}), do: length(received_messages) > 0
  def terminated?(program), do: halted?(program) || (waiting?(program) && !has_pending_received_messages?(program))

  def get(%Program{registry: registry}, value) do
    Registry.get(registry, value)
  end

  def set(program = %Program{registry: registry}, register, value) do
    %Program{
      program | registry: Registry.write(registry, register, get(program, value))
    }
  end

  def ok(program) do
    %Program{program | status: :ok}
  end

  def send_message(program = %Program{sent_messages: sent_messages, sent_counter: sent_counter}, value) do
    message = get(program, value)
    %Program{program | sent_messages: [message | sent_messages], sent_counter: sent_counter + 1}
  end

  def receive_message(program = %Program{received_messages: []}, _) do
    %Program{program | status: :waiting}
  end

  def receive_message(program = %Program{received_messages: [head | tail]}, register) do
    %Program{program | received_messages: tail} |> set(register, head)
  end

  def push_received_messages(program = %Program{received_messages: received_messages}, messages) do
    %Program{program | received_messages: received_messages ++ Enum.reverse(messages)}
  end

  def clear_sent_messages(program) do
    %Program{program | sent_messages: []}
  end

  def step(program = %Program{current_index: current_index}, diff \\ 1) do
    %Program{program | current_index: current_index + diff}
  end

  def jump(program, register, value) do
    step(program, (if get(program, register) > 0, do: get(program, value), else: 1))
  end

  # Stop execution if program is awaiting for a new message
  def run(program = %Program{status: :waiting, current_index: current_index}) do
    %Program{program | current_index: current_index - 1}
  end

  # Stop execution if there are no more instructions left
  def run(program = %Program{instructions: instructions, current_index: current_index}) when current_index >= length(instructions) do
    %Program{program | status: :halted}
  end

  def run(program = %Program{registry: registry, instructions: instructions, current_index: current_index}) do
    case Enum.at(instructions, current_index) do
      {:snd, value} ->
        program |> ok |> send_message(value) |> step |> run
      {:rcv, to_register} ->
        program |> ok |> receive_message(to_register) |> step |> run
      {:jgz, register, value} ->
        program |> ok |> jump(register, value) |> run
      instruction ->
        %Program{program | registry: Registry.run(registry, instruction)} |> ok |> step |> run
    end
  end
end
