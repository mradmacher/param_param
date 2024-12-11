# frozen_string_literal: true

require 'optiomist'
require 'param_param/result'
require 'param_param/actions'

# It allows to define actions that transform hash values.
# Each actions is bound to a particular key and processes a value related to that key.
#
# Actions could be chained and executed one by one.
# An actions receives a value from a previous action and is expected to return successful or failed result.
# A successful result contains a new value being the result of the processing.
# The new value is passed further in the chain to the next action.
# A failed result contains a message from an action saying why a particular value can't be processed.
# Following actions in the chain are not executed.
module ParamParam
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def define(&)
      Actions.new(yield(self))
    end
  end

  # A chain of actions that are executed consecutively
  # and pass a value from a previous action to the following one.
  #
  # If some action fails the chain is broken and value stops being processed.
  ALL_OF = lambda do |fns, option|
      fns.reduce(Success.new(option)) { |result, fn| result.failure? ? result : fn.call(result.value) }
  end.curry

  # Always succeeds with the provided +option+.
  ANY = lambda do |option|
    Success.new(option)
  end
end
