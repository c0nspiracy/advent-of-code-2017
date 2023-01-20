# frozen_string_literal: true

input = ARGF.read.chomp.split.map(&:to_i)
n_banks = input.size

seen = {}
cycles = 0
seen[input] = cycles

loop do
  cycles += 1
  bank_with_most_blocks = input.index(input.max)
  blocks_to_redistribute = input[bank_with_most_blocks]
  input[bank_with_most_blocks] = 0
  ptr = (bank_with_most_blocks + 1) % n_banks
  blocks_to_redistribute.times do
    input[ptr] += 1
    ptr = (ptr + 1) % n_banks
  end

  break if seen.key?(input)

  seen[input] = cycles
end

loop_size = cycles - seen[input]
puts "Part 1: #{cycles}"
puts "Part 2: #{loop_size}"
