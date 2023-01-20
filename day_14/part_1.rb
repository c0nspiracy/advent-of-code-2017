# frozen_string_literal: true

require_relative "../day_10/knot_hash"
input = ARGF.read

grid = 128.times.map do |n|
  hash = KnotHash.new("#{input}-#{n}").hash
  hash.chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0") }.join.count("1")
end

puts grid.sum
