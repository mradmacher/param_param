# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'param_param'
require 'param_param/std'

class UserParams
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  capitalized = ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }

  RULES = define.(
    name: required.(
      string.(all_of.([not_blank, max_size.(50), capitalized]))
    ),
    admin: required.(bool.(any)),
    age: optional.(integer.(gt.(0))),
  )

  def process(params)
    RULES.(params)
  end
end

raw_params = { name: 'JOHN', admin: '0', age: '30', race: 'It is not important' }
params, errors = UserParams.new.process(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)
p params
p errors

params, errors = UserParams.new.process(admin: 'no', age: 'very old')
p params
p errors
