components = "scripts/inputs/day_24.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&Day24.Component.parse/1)
  |> Enum.to_list
IO.puts "Part 1: #{Day24.Bridge.generate(components, &Day24.Bridge.stronger?/2) |> Day24.Bridge.strength}"
IO.puts "Part 1: #{Day24.Bridge.generate(components, &Day24.Bridge.longer_or_stronger?/2) |> Day24.Bridge.strength}"
