# frozen_string_literal: true

def scanner_position_at(time, range)
  div, mod = time.divmod range
  div.odd? ? range - mod : mod
end

class Firewall
  def initialize(input)
    @input = input
    @max_layers = input.keys.max
    @max_depth = input.values.max
    @elapsed = 0
  end

  def delay(n)
    @elapsed = n
  end

  def run
    caught = []

    (0..@max_layers).each do |packet_position|
      if @input.key?(packet_position) && scanner_position_at(@elapsed, @input[packet_position] - 1) == 0
        caught << packet_position
      end

      @elapsed += 1
    end

    [!caught.empty?, caught.sum { |n| n * @input[n] }]
  end
end

input = ARGF.readlines(chomp: true).map { |line| line.split(": ").map(&:to_i) }.to_h

firewall = Firewall.new(input)

caught, severity = firewall.run
puts "Part 1: #{severity}"

delay = 0
loop do
  break if severity == 0 && !caught

  delay += 1
  next if input.any? { |layer, range| scanner_position_at(delay + layer, range - 1) == 0 }

  firewall = Firewall.new(input)
  firewall.delay(delay)

  caught, severity = firewall.run
end

puts "Part 2: #{delay}"
