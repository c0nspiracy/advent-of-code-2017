# frozen_string_literal: true

input = ARGF.readlines(chomp: true).map(&:to_i)

pos = 0
steps = 0

loop do
  break if pos < 0 || pos >= input.size

  ins = input[pos]
  input[pos] += (ins >= 3 ? -1 : 1)
  pos += ins
  steps += 1
end

puts steps
