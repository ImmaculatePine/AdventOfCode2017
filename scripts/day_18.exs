instructions = "scripts/inputs/day_18.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.to_list

# Part 1
last_played_frequency = instructions |> Day18.Registry.run |> Day18.Registry.read_meta(:last_played_frequency)
IO.puts "Part 1: #{last_played_frequency}"

# Part 2
{_, %{sent_counter: sent_counter}} = Day18.Duet.start(instructions)
IO.puts "Part 2: #{sent_counter}"
