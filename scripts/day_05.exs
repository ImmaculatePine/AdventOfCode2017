instructions = "scripts/inputs/day_05.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&String.to_integer/1)
  |> Enum.to_list

IO.puts "Part 1: #{Day5.Jump.run(instructions, &Day5.Jump.increment/1)}"
IO.puts "Part 2: #{Day5.Jump.run(instructions, &Day5.Jump.custom_increment/1)}"
