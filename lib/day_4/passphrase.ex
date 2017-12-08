defmodule Day4.Passphrase do
  @doc """
      iex> Day4.Passphrase.valid?("aa bb cc dd ee")
      true
      iex> Day4.Passphrase.valid?("aa bb cc dd aa")
      false
      iex> Day4.Passphrase.valid?("aa bb cc dd aaa")
      true
  """
  def valid?(phrase) do
    words = String.split(phrase, " ", trim: false)
    words |> length == words |> Enum.uniq |> length
  end
end
