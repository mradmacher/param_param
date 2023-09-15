# frozen_string_literal: true

$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'minitest/autorun'
require 'minitest/spec'
require 'param_param'

module PP
  include ParamParam
end
