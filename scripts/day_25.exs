tape = "scripts/inputs/day_25.txt"
  |> File.read!
  |> Day25.Parser.parse
  |> Day25.Machine.run

IO.puts "Part 1: #{Day25.Machine.checksum(tape)}"
