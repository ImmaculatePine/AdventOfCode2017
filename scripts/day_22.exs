grid = "scripts/inputs/day_22.txt"
  |> File.read!
  |> Day22.Grid.parse

{_, infected_count} = Day22.Grid.go(grid, 10000, Day22.Part1)
IO.puts "Part 1: #{infected_count}"

{_, infected_count} = Day22.Grid.go(grid, 10000000, Day22.Part2)
IO.puts "Part 2: #{infected_count}"
