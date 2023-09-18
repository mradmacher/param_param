# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'param_param'

module Mather
  include ParamParam

  def self.add
    ->(value, option) { Success.new(Optiomist.some(option.value + value)) }.curry
  end

  def self.mul
    ->(value, option) { Success.new(Optiomist.some(option.value * value)) }.curry
  end

  def self.sub
    ->(value, option) { Success.new(Optiomist.some(option.value - value)) }.curry
  end
end

rules = Mather.define.(
  a: Mather.add.(5),
  b: Mather.mul.(3),
  c: Mather.sub.(1),
  d: Mather.all_of.([Mather.add.(2), Mather.mul.(2), Mather.sub.(2)]),
)

params, errors = rules.(
  a: 0,
  b: 1,
  c: 2,
  d: 3,
)
p params
p errors
