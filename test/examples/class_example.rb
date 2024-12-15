# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'param_param'
require 'param_param/std'

class MyParams
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  CAPITALIZED = ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }
end

user_params = MyParams.define do |p|
  {
    name: p::REQUIRED.(p::ALL_OF.([p::STRING, p::MIN_SIZE.(1), p::MAX_SIZE.(50), p::CAPITALIZED])),
    admin: p::REQUIRED.(p::BOOL),
    age: p::OPTIONAL.(p::ALL_OF.([p::INTEGER, p::GT.(0)])),
  }
end

params, errors = user_params.(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)
p params
p errors

params, errors = user_params.(admin: 'no', age: 'very old')
p params
p errors
