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
  #puts "Neighbouring cells for [#{y}, #{x}] => #{neighbours.map { |ny,nx| "[#{ny}, #{nx}]" }.join(", ") }"
  neighbours
end

regions = { 1 => [[0, 0]] }
grid_region = { [0, 0] => 1 }
region_id = 1

loop do
  #puts "Region #{region_id}"
  # reach out to find neighbours that haven't been marked with the region
  new_coords = regions[region_id]
  round = 0
  loop do
    #puts "Round #{round}" if region_id == 59
    frontier = new_coords
    new_coords = []
    frontier.each do |y, x|
      neighbours = neighbouring_cells(y, x)
      neighbours.reject! { |ny, nx| grid[ny][nx] == "0" || grid_region.include?([ny, nx]) }
      new_coords.concat(neighbours)
    end

    break if new_coords.empty?

    new_coords.each do |ny, nx|
      regions[region_id] << [ny, nx]
      grid_region[[ny, nx]] = region_id
      #puts "Adding #{ny}, #{nx} to region #{region_id}" if region_id == 59
    end
    round += 1
  end

  # find the next cell without a region
  next_cell = nil
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if cell == "0"
      next if grid_region.key?([y, x])

      next_cell = [y, x]
      break
    end
    break unless next_cell.nil?
  end

  break if next_cell.nil?
  region_id = regions.keys.max.to_i + 1
  regions[region_id] ||= [next_cell]
  grid_region[next_cell] = region_id
end


# grid.each_with_index do |row, y|
#   row.each_with_index do |cell, x|
#     next if cell == "0"
#     next if grid_region.key?([y, x])

#     neighbours = neighbouring_cells(y, x)

#     region_id = grid_region.values_at(*neighbours).compact.first
#     if region_id.nil?
#       region_id = regions.keys.max.to_i + 1
#       regions[region_id] ||= []
#     end

#     regions[region_id] << [y, x]
#     grid_region[[y, x]] = region_id
#   end
# end

(0..7).each do |y|
  row = (0..7).map { |x|
    r = grid_region[[y, x]]
    r.nil? ? " ." : r.to_s.rjust(2, " ")
  }.join
  puts row
end

puts regions.keys.count
# puts grid.inspect
