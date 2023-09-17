# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'param_param'
require 'param_param/std'

module PP
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  def self.capitalized
    ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }
  end
end

rules = PP.define.(
  name: PP.required.(
    PP.string.(PP.all_of.([PP.not_blank, PP.max_size.(50), PP.capitalized]))
  ),
  admin: PP.required.(PP.bool.(PP.any)),
  age: PP.optional.(PP.integer.(PP.gt.(0))),
)

params, errors = rules.(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)
p params
p errors

params, errors = rules.(admin: 'no', age: 'very old')
p params
p errors
