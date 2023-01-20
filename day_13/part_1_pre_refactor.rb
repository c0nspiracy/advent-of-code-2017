# frozen_string_literal: true

def display(max_depth, max_layers, input, scanners, packet_position, pico = nil)
  if pico == -1
    puts "Initial state:"
  elsif !pico.nil?
    puts "Picosecond #{pico}:"
  end
  puts " " + (0..max_layers).to_a.join("   ")

  (0...max_depth).each do |depth|
    line = []
    (0..max_layers).each do |layer|
      if depth == 0 && packet_position == layer
        b1, b2 = ["(", ")"]
      else
        b1, b2 = ["[", "]"]
      end

      if input.key?(layer) && depth < input[layer]
        if scanners[layer] == depth
          line << "#{b1}S#{b2}"
        else
          line << "#{b1} #{b2}"
        end
      elsif depth == 0
        if b1 == "("
          line << "#{b1}.#{b2}"
        else
          line << "..."
        end
      else
        if b1 == "("
          line << "#{b1} #{b2}"
        else
          line << "   "
        end
      end
    end
    puts line.join(" ")
  end
  puts
end

input = ARGF.readlines(chomp: true).map { |line| line.split(": ").map(&:to_i) }.to_h
scanners = Hash.new(0)
scanner_deltas = Hash.new { |h, k| h[k] = 1 }

max_layers = input.keys.max
max_depth = input.values.max
packet_position = 0

display(max_depth, max_layers, input, scanners, -1, -1)

caught = []
(0..max_layers).each do |packet_position|
  display(max_depth, max_layers, input, scanners, packet_position, packet_position)
  if input.key?(packet_position) && scanners[packet_position] == 0
    puts "Caught at #{packet_position}!"
    caught << packet_position
  end

  input.each_key do |layer|
    sd = scanner_deltas[layer]
    if sd == 1 && scanners[layer] == input[layer] - 1
      scanner_deltas[layer] = -1
    elsif sd == -1 && scanners[layer] == 0
      scanner_deltas[layer] = 1
    end
    scanners[layer] = scanners[layer] + scanner_deltas[layer]
  end
  display(max_depth, max_layers, input, scanners, packet_position)
end

puts caught.sum { |n| n * input[n] }
