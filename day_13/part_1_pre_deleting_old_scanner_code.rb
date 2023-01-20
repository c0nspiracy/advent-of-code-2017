# frozen_string_literal: true

def scanner_position_at(time, range)
  div, mod = time.divmod range
  div.odd? ? range - mod : mod
end

class Firewall
  def initialize(input)
    @input = input
    @scanner_positions = Hash.new(0)
    @scanner_deltas = Hash.new { |h, k| h[k] = 1 }
    @max_layers = input.keys.max
    @max_depth = input.values.max
    @delayed = 0
    @elapsed = 0
  end

  def delay(n)
    @delayed = n
    @elapsed = n
    n.times { move_scanners }
  end

  def run
    caught = []

    (0..@max_layers).each do |packet_position|
      # display(packet_position)

      if @input.key?(packet_position) && scanner_position_at(@elapsed, @input[packet_position] - 1) == 0#@scanner_positions[packet_position] == 0
        caught << packet_position
      end

      # @scanner_positions.each do |layer, depth|
      #   binding.irb if depth != scanner_position_at(@elapsed, @input[layer] - 1)
      # end

      @elapsed += 1
      #move_scanners

      # display(packet_position, false)
    end

    [!caught.empty?, caught.sum { |n| n * @input[n] }]
  end

  def move_scanners
    @input.each_key do |layer|
      sd = @scanner_deltas[layer]
      if sd == 1 && @scanner_positions[layer] == @input[layer] - 1
        @scanner_deltas[layer] = -1
      elsif sd == -1 && @scanner_positions[layer] == 0
        @scanner_deltas[layer] = 1
      end
      @scanner_positions[layer] = @scanner_positions[layer] + @scanner_deltas[layer]
    end
  end

  def display(pico, show_message = true)
    return
    if show_message
      if pico == -1
        if @delayed > 0
          puts "State after delaying:"
        else
          puts "Initial state:"
        end
      else
        puts "Picosecond #{pico + @delayed}:"
      end
    end
    puts " " + (0..@max_layers).to_a.join("   ")

    (0...@max_depth).each do |depth|
      line = []
      (0..@max_layers).each do |layer|
        if depth == 0 && pico == layer
          b1, b2 = ["(", ")"]
        else
          b1, b2 = ["[", "]"]
        end

        if @input.key?(layer) && depth < @input[layer]
          if @scanner_positions[layer] == depth
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
end

input = ARGF.readlines(chomp: true).map { |line| line.split(": ").map(&:to_i) }.to_h

firewall = Firewall.new(input)
# firewall.display(-1)

caught, severity = firewall.run
puts "Part 1: #{severity}"

delay = 0
loop do
  break if severity == 0 && !caught

  delay += 1
  next if input.any? { |layer, range| scanner_position_at(delay + layer, range - 1) == 0 }

  firewall = Firewall.new(input)
  firewall.delay(delay)
  # firewall.display(-1)

  caught, severity = firewall.run
end

puts "Part 2: #{delay}"
