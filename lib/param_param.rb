# frozen_string_literal: true

require 'optiomist'
require 'param_param/result'

# It allows to define pipelines that transform hash values.
#
# Each pipeline is bound to a particular key and processes a value related to that key.
# A pipeline consists of a chain of actions that are executed one by one.
# An actions receives a value from a previous action and is expected to return successful or failed result.
# A successful result contains a new value being the result of the processing.
# The new value is passed further in the chain to the next action.
# A failed result contains a message from an action saying why a particular value can't be processed.
# Following actions in the chain are not executed.
module ParamParam
  def self.included(base)
    base.extend(Actions)
  end

  # Actions definitions.
  module Actions
    # Converts provided value to +Optiomist::Some+.
    # If the value is already +Optiomist::Some+ or +Optiomist::None+ returns it untouched.
    def optionize(value)
      if value.is_a?(Optiomist::Some) || value.is_a?(Optiomist::None)
        value
      else
        Optiomist.some(value)
      end
    end

    # Defines pipelines and binds them to symbols.
    # Pipelines are used to process parameters provided in a form of a hash.
    # Each pipeline is defined for a key and processes a value related to that key in provided parameters.
    #   lambda { |rules, params| ... }
    #
    # The lambda returns two hashes:
    # - if a value related to a key can be procesed by an action,
    #   the result is bound to the key and added to the first hash
    # - if a value related to a key can't be processed by an action,
    #   the error is bound to the key and added to the second hash
    #
    # Each action needs to be a lambda taking +Optiomist+ as the only or the last parameter and returning either:
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
