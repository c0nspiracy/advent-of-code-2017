# frozen_string_literal: true

input = ARGF.read.chomp

strpos = 0
group_level = 0
garbage_mode = false
garbage_count = 0
score = 0

loop do
  char = input[strpos]
  skip = 1

  case char
  when "!"
    # Skip next character
    skip = 2
  when "{"
    if garbage_mode
      garbage_count += 1
    else
      group_level += 1
    end
  when "<"
    garbage_count += 1 if garbage_mode
    garbage_mode = true
  when ">"
    garbage_mode = false
  when "}"
    if garbage_mode
      garbage_count += 1
    else
      group_level -= 1
      score += group_level + 1
    end
  else
    garbage_count += 1 if garbage_mode
  end

  strpos += skip

  break if strpos >= input.length
end

puts "Part 1: #{score}"
puts "Part 2: #{garbage_count}"
