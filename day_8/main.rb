# frozen_string_literal: true

input = ARGF.readlines(chomp: true)

registers = Hash.new { |h, k| h[k] = 0 }
max_held = 0

input.each do |line|
  s_reg, op_a, n, c_reg, op_b, v = line.scan(/(\w+) (inc|dec) (-?\d+) if (\w+) (.{1,2}) (-?\d+)/).first
  n = n.to_i
  v = v.to_i
  if registers[c_reg].send(op_b, v)
    case op_a
    when "inc"
      registers[s_reg] += n
    when "dec"
      registers[s_reg] -= n
    end
  end

  max_held = [max_held, registers.values.max].max
end

puts "Part 1: #{registers.values.max}"
puts "Part 2: #{max_held}"
