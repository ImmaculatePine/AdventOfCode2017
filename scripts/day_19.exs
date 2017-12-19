path = "scripts/inputs/day_19.txt"
  |> File.read!
  |> Day19.Path.parse
IO.puts "Part 1: #{Day19.Path.traverse(path)}"
