# frozen_string_literal: true

require 'param_param/option'
require 'param_param/result'

# The main purpose of this module is to convert hash data
# applying a chain of rules to values in the provided hash.
#
# It can be used to process form data in a web application converting
# user provided data to values understood by the application and validate
# it the data fulfills constraints required by the application.
#
# Example:
#
#   class UserOperation
#     include ParamParam
#     include ParamParam::Std
#
#     UserParams = Rules.(
#       name: Required.(IsString.(AllOf.([NotNil, Stripped, MaxSize.(50)]))),
#       age: Optional.(IsInteger.(Gt.(0))),
#     )
#
#     def create(name:, age:)
#       params, errors = UserParams.(name: name, age: age)
#       throw errors unless errors.empty?
#
#       # do something with params
#     end
#   end
module ParamParam
  # Converts provided value to +Options::Some+.
  # If the value is already +Option::Some+ or +Option::None+ returns it untouched.
  def self.optionize(value)
    if value.is_a?(Option::Some) || value.is_a?(Option::None)
      value
    else
      Option.Some(value)
    end
  end

  # Lambda that allows defining a set of rules and bind them to symbols.
  # Later those rules can be applied to parameters provided in a for of a hash.
  # Each rule defined for a given key processes a value related to the same key in provided parameters.
  #
  # It returns two hashes:
  # - if a value related to a key can be procesed by the rules,
  #   the result is bound to the key and added to the first hash
  # - if a rule can't be applied to a value,
  #   the error is bound to the key and added to the second hash
  #
  # Each rule needs to be a lambda taking +Option+ as a parameter and returning either:
  # - +Result::Success+ with processed option
  # - +Result::Failure+ with an error
  Rules = lambda { |rules, params|
    results = rules.to_h do |key, fn|
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

  # Lambda that allows defining a chain of rules that will be applied one by one to value processed by a previous rule.
  # If some rule fails the chain is broken and value stops being processed.
  AllOf = lambda { |fns, option|
    fns.reduce(Result::Success.new(option)) { |result, fn| result.failure? ? result : fn.call(result.value) }
  }.curry
end
