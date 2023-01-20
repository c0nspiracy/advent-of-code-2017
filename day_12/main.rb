# frozen_string_literal: true

require "set"

input = ARGF.readlines(chomp: true)
map = {}
input.map do |program|
  program_id, connected_ids = program.split(" <-> ")
  map[program_id.to_i] = connected_ids.split(", ").map(&:to_i)
end

current_program = 0
connected_to = Hash.new { |h, k| h[k] = Set.new([current_program]) }

loop do
  loop do
    new_connections = connected_to[current_program].flat_map { |k| map.delete(k) }.compact
    break if new_connections.empty?

    connected_to[current_program] += new_connections
  end

  break if map.empty?
  current_program = map.keys.first
end

puts "Part 1: #{connected_to[0].size}"
puts "Part 2: #{connected_to.size}"
