grid = "scripts/inputs/day_22.txt"
  |> File.read!
  |> Day22.Grid.parse
{_, infected_count} = Day22.Grid.go(grid, 10000)
IO.puts "Part 1: #{infected_count}"
