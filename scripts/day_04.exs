filepath = "scripts/inputs/day_04.txt"
IO.puts "Part 1: #{Day4.Counter.count(filepath, &Day4.Passphrase.valid?/1)}"
IO.puts "Part 2: #{Day4.Counter.count(filepath, &Day4.AnagramPassphrase.valid?/1)}"
