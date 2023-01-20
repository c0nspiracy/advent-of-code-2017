# frozen_string_literal: true

input = ARGF.readlines(chomp: true)
valid_passphrase_count = input.count do |passphrase|
  passphrase.split.tally.values.none? { |n| n > 1 }
end

puts "Part 1: #{valid_passphrase_count}"

valid_passphrase_count = input.count do |passphrase|
  words = passphrase.split
  words.map { |word| word.chars.sort.join }.tally.values.none? { |n| n > 1 }
end

puts "Part 2: #{valid_passphrase_count}"
