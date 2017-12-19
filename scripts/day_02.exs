input = "scripts/inputs/day_02.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(fn line -> line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
  |> Enum.to_list

IO.puts "Part 1: #{Day2.Checksum.calculate(input)}"
IO.puts "Part 2: #{Day2.Checksum.calculate2(input)}"
