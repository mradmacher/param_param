# frozen_string_literal: true

require 'optiomist'
require 'param_param/result'

# It provides functionality to define a collection of rules that can convert values in a hash.
#
# Each rule is bound to a particular key and processes a value related to that key.
# A rule consists of a chain of functions that are processed one by one.
# A functions receives a value and is expected to return successful or failed result.
# A successful result contains a new value being the result of the processing.
# The new value is passed further in the chain to the next function.
# Failed result contains a message from the function saying why a particular value can't be processed.
# The following formulas in the chain are not executed.
module ParamParam
  def self.included(base)
    base.extend(Functions)
  end

  # Functions definitions.
  module Functions
    # Converts provided value to +Optiomist::Some+.
    # If the value is already +Optiomist::Some+ or +Optiomist::None+ returns it untouched.
    def optionize(value)
      if value.is_a?(Optiomist::Some) || value.is_a?(Optiomist::None)
        value
      else
        Optiomist.some(value)
      end
    end

    # Returns lambda that allows defining a set of rules and bind them to symbols.
    # Later those rules can be applied to parameters provided in a for of a hash.
    # Each rule defined for a given key processes a value related to the same key in provided parameters.
    #   lambda { |rules, params| ... }
    #
    # The lambda returns two hashes:
    # - if a value related to a key can be procesed by the rules,
    #   the result is bound to the key and added to the first hash
    # - if a rule can't be applied to a value,
    #   the error is bound to the key and added to the second hash
    #
    # Each rule needs to be a lambda taking +Optiomist+ as the only or the last parameter and returning either:
    # - +ParamParam::Success+ with processed option
    # - +ParamParam::Failure+ with an error
    def define
      lambda { |rules, params|
        results = rules.to_h do |key, fn|
          option = params.key?(key) ? optionize(params[key]) : Optiomist.none
          [key, fn.call(option)]
        end

        errors = results.select { |_, result| result.failure? }
                        .transform_values(&:error)
        params = results.select { |_, result| result.success? && result.value.some? }
                        .transform_values { |result| result.value.value }
        [params, errors]
      }.curry
    end

    # It return lambda that allows defining a chain of rules that will be applied one by one
    # to value processed by a previous rule.
    #
    # Returns:
    #   lambda { |fns, option| ... }
    # If some rule fails the chain is broken and value stops being processed.
    def all_of
      lambda { |fns, option|
        fns.reduce(Success.new(option)) { |result, fn| result.failure? ? result : fn.call(result.value) }
      }.curry
    end

    # Returns
    #  lambda { |option| ... }.
    #
    # Always succeeds with the provided +option+.
    def any
      ->(option) { Success.new(option) }
    end
  end
end
