# frozen_string_literal: true

class Tower
  def initialize(input)
    @programs = {}
    @structure = Hash.new { |h, k| h[k] = [] }
    parse(input)
  end

  def balanced?(program)
    sub_programs(program).map { |sp| rec_weight(sp) }.uniq.count == 1
  end

  def walk
    candidates = [bottom_program]
    program = nil

    loop do
      break if candidates.empty?

      program = candidates.shift
      break if balanced?(program)

      candidates.concat sub_programs(program)
    end

    program
  end

  def sub_programs(program)
    @structure.select { |_, v| v.include?(program) }.keys
  end

  def rec_weight(program)
    @programs[program] + sub_programs(program).sum { |sp| rec_weight(sp) }
  end

  def anomaly_weight(program)
    weights = sub_programs(program).map { |sp| [sp, rec_weight(sp)] }.to_h
    anomaly = weights.values.tally.select { |_, v| v == 1 }.keys.first
    anomaly_key = weights.key(anomaly)
    correct_weight = (weights.values - [anomaly]).first
    anomaly_diff = anomaly - correct_weight
    [anomaly_key, anomaly_diff]
  end

  def bottom_program
    (@programs.keys - @structure.keys).first
  end

  private

  def parse(input)
    input.each do |line|
      name, weight, names = line.scan(/(\w+) \((\d+)\)(?: -> (.+))?/).first
      @programs[name] = weight.to_i
      names ||= ""
      names.split(", ").each { |n| @structure[n] << name }
    end
  end
end

input = ARGF.readlines(chomp: true)
tower = Tower.new(input)
puts tower.bottom_program

binding.irb
