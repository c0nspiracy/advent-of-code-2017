# frozen_string_literal: true

require_relative "./knot_hash"

puts KnotHash.new(ARGF.read.chomp).hash
