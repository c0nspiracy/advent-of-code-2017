# frozen_string_literal: true

def odd_square(n)
  ((2 * n) + 1) ** 2
end

input = ARGF.read.to_i

level = (Math.sqrt(input).ceil - 1).fdiv(2).ceil

range_start = odd_square(level - 1) + 1
range_end = odd_square(level)
range_size = range_end - range_start + 1
corner = range_size / 4
seq = (corner - 1).downto(level)
seq += (level + 1).upto(corner)
distances = seq.cycle.take(range_size)
answer = distances[input - range_start] || 0
puts "Part 1: #{answer}"
puts "Part 2: see https://oeis.org/A141481/b141481.txt"
