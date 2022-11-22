# frozen_string_literal: true

require 'param_param/option'
require 'param_param/result'
require 'param_param/rules'

##
# The main purpose of this module is to convert hash data
# (e.g. form data in a web application) applying a chain of rules
# to each value in the provided hash.
#
# If returns two hashes:
# - first with successfully converted values
# - second with errors that prevented applying the rules.

module ParamParam
  def self.optionize(value)
    if value.is_a?(Option::Some) || value.is_a?(Option::None)
      value
    else
      Option.Some(value)
    end
  end

  Rules = lambda { |fields, params|
    results = fields.to_h do |key, fn|
      option = params.key?(key) ? optionize(params[key]) : Option.None
      [key, fn.call(option)]
    end

    errors = results.select { |_, result| result.failure? }.transform_values(&:error)
    successful_with_values = results.select do |_, result|
      result.success? && result.value.some?
    end
    params = successful_with_values.transform_values { |result| result.value.value }
    [params, errors]
  }.curry

  AllOf = lambda { |fns, option|
    fns.reduce(Success.new(option)) { |result, fn| result.is_a?(Failure) ? result : fn.call(result.value) }
  }.curry
end
