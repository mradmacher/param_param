# frozen_string_literal: true

module ParamParam
  # Defines actions to process hash values.
  #
  # An action is a lambda function assigned to a key.
  # When a hash with values is provied, a value related to a key of the same name as the one the action is assigned to, processes the value.
  #
  # An action needs to be a lambda taking +Optiomist+ option as parameter and returning either:
  # - +ParamParam::Success+ with processed option
  # - +ParamParam::Failure+ with an error
  #
  # Example:
  #  actions = Actions.new(
  #    key: lambda { |option| option.some? ? Success.new(process(option.value)) : Failure.new(:missing) },
  #    ...
  #  )
  class Actions
    def initialize(actions)
      @actions = actions
    end

    # It takes a hash and processes values related to a key by an action assigned to the same key.
    #
    # It returns two hashes:
    # - if a value related to a key can be procesed by an action,
    #   the result is bound to the key and added to the first params hash
    # - if a value related to a key can't be processed by an action,
    #   the error is bound to the key and added to the last errors hash
    def call(params)
      results = actions.to_h do |key, fn|
        option = params.key?(key) ? optionize(params[key]) : Optiomist.none
        [key, fn.call(option)]
      end

      errors = results.select { |_, result| result.failure? }
                      .transform_values(&:error)
      params = results.select { |_, result| result.success? && result.value.some? }
                      .transform_values { |result| result.value.value }
      [params, errors]
    end

    private

    attr_reader :actions

    # Converts provided value to +Optiomist::Some+.
    # If the value is already +Optiomist::Some+ or +Optiomist::None+ returns it untouched.
    def optionize(value)
      if value.is_a?(Optiomist::Some) || value.is_a?(Optiomist::None)
        value
      else
        Optiomist.some(value)
      end
    end
  end
end
