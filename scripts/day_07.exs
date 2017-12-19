tower = "scripts/inputs/day_07.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.to_list
  |> Day7.Tower.new

{root, _} = Day7.Tower.root(tower)
fixed_weight = Day7.Tower.fix_error(tower)

IO.puts "Part 1: #{root}"
IO.puts "Part 2: #{fixed_weight}"
