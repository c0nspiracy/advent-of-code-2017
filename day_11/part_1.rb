# frozen_string_literal: true

max = 0
x = 0
y = 0

def distance(x, y)
  (x.abs + y.abs + (x + y).abs) / 2
end

path = ARGF.read.chomp.split(",")
path.each do |step|
  case step
  when "n"
    y += 1
  when "ne"
    x += 1
  when "se"
    x += 1
    y -= 1
  when "s"
    y -= 1
  when "sw"
    x -= 1
  when "nw"
    x -= 1
    y += 1
  end

  max = [max, distance(x, y)].max
end

puts "Part 1: #{distance(x, y)}"
puts "Part 2: #{max}"
