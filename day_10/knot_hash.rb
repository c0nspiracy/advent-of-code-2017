# frozen_string_literal: true

class KnotHash
  def initialize(input)
    @input = input
  end

  def hash
    list_size = 255
    list = (0..list_size).to_a
    current_position = 0
    skip_size = 0
    lengths = @input.chars.map(&:ord)
    lengths.concat [17, 31, 73, 47, 23]

    64.times do
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
    end

    list.each_slice(16).map { |slice| slice.inject(:^).to_s(16).rjust(2, "0") }.join
  end
end
