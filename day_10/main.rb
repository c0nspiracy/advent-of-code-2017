# frozen_string_literal: true

list_size = 255
list = (0..list_size).to_a
current_position = 0
skip_size = 0
lengths = ARGF.read.chomp.split(",").map(&:to_i)

lengths.each do |length|
  if length > 1
    if current_position + length > list_size
      list.rotate!(current_position)
      list[0, length] = list[0, length].reverse
      list.rotate!(-current_position)
    else
      list[current_position, length] = list[current_position, length].reverse
    end
  end

  current_position += length + skip_size
  skip_size += 1
end

puts list.first(2).inject(:*)
