defmodule Day8.Op do
  defstruct register: nil, action: nil, diff: 0, condition: nil 

  @doc """
      iex> Day8.Op.parse("gug dec 188 if zpw >= 8")
      %Day8.Op{register: :gug, action: :dec, diff: 188, condition: {:>=, :zpw, 8}}
      iex> Day8.Op.parse("pnt inc 428 if xek < 10")
      %Day8.Op{register: :pnt, action: :inc, diff: 428, condition: {:<, :xek, 10}}
      iex> Day8.Op.parse("sg dec -376 if kw != -1518")
      %Day8.Op{register: :sg, action: :dec, diff: -376, condition: {:!=, :kw, -1518}}
  """
  def parse(input) when is_binary(input) do
    ~r/(.+) (inc|dec) (-?\d+) if (.+) ([><=!]+) (-?\d+)/
      |> Regex.run(input)
      |> parse
  end

  def parse([_, register, action, diff, cond_register, cond_operator, cond_value]) do
    %Day8.Op{
      register: String.to_atom(register),
      action: String.to_atom(action),
      diff: String.to_integer(diff),
      condition: {String.to_atom(cond_operator), String.to_atom(cond_register), String.to_integer(cond_value)}
    }
  end
end
