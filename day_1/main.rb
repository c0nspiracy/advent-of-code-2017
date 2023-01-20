# frozen_string_literal: true

input = ARGF.readlines(chomp: true).first.chars.map(&:to_i)

def sum_digits(arr)
  arr.sum { |a, b| a == b ? a : 0 }
end

count = input.size
cycle = input.cycle

pairs = cycle.each_cons(2).take(count)
answer = sum_digits(pairs)
puts "Part 1: #{answer}"

offset_cycle = input.rotate(count / 2).cycle
pairs = cycle.lazy.zip(offset_cycle.lazy).take(count).to_a
answer = sum_digits(pairs)
puts "Part 2: #{answer}"
