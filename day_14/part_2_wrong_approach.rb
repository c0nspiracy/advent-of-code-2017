# frozen_string_literal: true

require_relative "../day_10/knot_hash"
input = ARGF.read

grid = 128.times.map do |n|
  hash = KnotHash.new("#{input}-#{n}").hash
  hash.chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0") }.join.chars
end

def neighbouring_cells(y, x)
  neighbours = []
  neighbours << [y - 1, x] if y > 0
  neighbours << [y, x - 1] if x > 0
  neighbours << [y, x + 1] if x < 127
  neighbours << [y + 1, x] if y < 127
  puts "Neighbouring cells for [#{y}, #{x}] => #{neighbours.map { |ny,nx| "[#{ny}, #{nx}]" }.join(", ") }"
  neighbours
end

regions = { 1 => [[0, 0]] }
grid_region = { [0, 0] => 1 }

grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if cell == "0"
    next if grid_region.key?([y, x])

    neighbours = neighbouring_cells(y, x)

    region_id = grid_region.values_at(*neighbours).compact.first
    if region_id.nil?
      region_id = regions.keys.max.to_i + 1
      regions[region_id] ||= []
    end

    regions[region_id] << [y, x]
    grid_region[[y, x]] = region_id
  end
end

(0..7).each do |y|
  row = (0..7).map { |x|
    r = grid_region[[y, x]]
    r.nil? ? " ." : r.to_s.rjust(2, " ")
  }.join
  puts row
end

binding.irb
# puts grid.inspect
