defmodule Day4.Counter do
  def count(filepath, validator) do
    File.stream!(filepath) 
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.filter(validator)
      |> Enum.to_list
      |> length
  end
end
