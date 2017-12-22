rules = "scripts/inputs/day_21.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.to_list
  |> Enum.reduce(%{}, fn rule, acc -> Day21.Rule.add(acc, rule) end)

IO.puts "Part 1: #{Day21.Fractal.on_pixels_count(rules, 5)}"
