# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'param_param'

module Mather
  include ParamParam

  ADD = ->(value, option) { Success.new(Optiomist.some(option.value + value)) }.curry
  MUL = ->(value, option) { Success.new(Optiomist.some(option.value * value)) }.curry
  SUB = ->(value, option) { Success.new(Optiomist.some(option.value - value)) }.curry
end

rules = Mather.define do |m|
  {
    a: m::ADD.(2),
    b: m::MUL.(2),
    c: m::SUB.(2),
    d: m::ALL_OF.([m::ADD.(2), m::MUL.(2), m::SUB.(2)]),
  }
end

params, errors = rules.(
  a: 10,
  b: 10,
  c: 10,
  d: 10,
)
p params
p errors
