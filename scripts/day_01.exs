input = File.read!("scripts/inputs/day_01.txt")
IO.puts "Part 1: #{Day1.Captcha.solve(input)}"
IO.puts "Part 2: #{Day1.Captcha.solve2(input)}"
