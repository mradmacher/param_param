# frozen_string_literal: true

require 'param_param/option'
require 'param_param/result'
require 'param_param/rules'

module ParamParam
  def self.optionize(value)
    if value.is_a?(Option::Some) || value.is_a?(Option::None)
      value
    else
      Option.Some(value)
    end
  end

  Rules = lambda { |fields, params|
    result = fields.to_h do |key, fn|
      value = params.key?(key) ? optionize(params[key]) : Option.None
      [key, fn.call(value)]
    end

    errors = result.select { |_, v| v.is_a?(Failure) }.transform_values(&:error)
    if errors.empty?
      successful_with_values = result.select do |_, v|
        v.is_a?(Success) && v.value.is_a?(Option::Some)
      end
      params = successful_with_values.transform_values { |v| v.value.value }
      Success.new(params)
    else
      Failure.new(errors)
    end
  }.curry

  AllOf = lambda { |fns, v|
    fns.reduce(Success.new(v)) { |result, fn| result.is_a?(Failure) ? result : fn.call(result.value) }
  }.curry
end
