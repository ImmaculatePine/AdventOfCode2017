particles = "scripts/inputs/day_20.txt"
  |> File.stream!
  |> Stream.map(&String.trim_trailing/1)
  |> Stream.map(&Day20.Particle.parse/1)
  |> Enum.to_list

IO.puts "Part 1: #{Day20.Particle.closest(particles)}"
IO.puts "Part 2: #{particles |> Day20.Particle.remove_collisions |> length}"
