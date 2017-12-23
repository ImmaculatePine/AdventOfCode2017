{_, counter} = "scripts/inputs/day_23.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&Day23.Op.parse/1)
  |> Enum.to_list
  |> Day23.Registry.run
IO.puts "Part 1: #{counter[:mul]}"
