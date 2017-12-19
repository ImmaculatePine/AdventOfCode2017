{cycles_count, loop_size} = "scripts/inputs/day_06.txt"
  |> File.read!
  |> String.split(~r/\s/, trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Day6.MemoryReallocation.run

IO.puts "Part 1: #{cycles_count}"
IO.puts "Part 2: #{loop_size}"
