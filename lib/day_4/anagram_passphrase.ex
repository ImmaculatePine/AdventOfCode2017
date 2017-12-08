defmodule Day4.AnagramPassphrase do
  @doc """
      iex> Day4.AnagramPassphrase.valid?("abcde fghij")
      true
      iex> Day4.AnagramPassphrase.valid?("abcde xyz ecdab")
      false
      iex> Day4.AnagramPassphrase.valid?("a ab abc abd abf abj")
      true
      iex> Day4.AnagramPassphrase.valid?("iiii oiii ooii oooi oooo")
      true
      iex> Day4.AnagramPassphrase.valid?("oiii ioii iioi iiio")
      false
  """
  def valid?(phrase) when is_binary(phrase) do
    phrase |> String.split(" ", trim: false) |> valid?
  end

  def valid?([single_world]) do
    true
  end

  def valid?([head | tail]) do
    !Enum.any?(tail, &anagram?(&1, head)) && valid?(tail)
  end

  @doc """
      iex> Day4.AnagramPassphrase.anagram?("abcde", "fghij")
      false
      iex> Day4.AnagramPassphrase.anagram?("abcde", "ecdab")
      true
  """
  def anagram?(word1, word2) do
    word1 |> String.to_charlist |> Enum.sort == word2 |> String.to_charlist |> Enum.sort
  end
end
