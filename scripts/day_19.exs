{collected, steps} = "scripts/inputs/day_19.txt"
  |> File.read!
  |> Day19.Path.parse
  |> Day19.Path.traverse
IO.puts "Part 1: #{Enum.join(collected)}"
IO.puts "Part 2: #{steps}"
