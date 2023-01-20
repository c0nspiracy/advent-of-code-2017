# frozen_string_literal: true

input = ARGF.readlines(chomp: true).map do |line|
  line.split.map(&:to_i)
end

answer = input.sum do |numbers|
  numbers.minmax.reverse.reduce(:-)
end

puts "Part 1: #{answer}"

answer = input.sum do |numbers|
  numbers.permutation(2).detect { |c, d| (c % d).zero? }.reduce(:/)
end

puts "Part 2: #{answer}"
