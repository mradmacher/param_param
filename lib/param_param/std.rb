# frozen_string_literal: true

module ParamParam
  # It defines some actions that can be useful in an everyday life.
  module Std
    # Some string values that can be considered as +true+ (thank you dry-rb for inspiration).
    TRUE_VALUES = %w[1 on On ON t true True TRUE T y yes Yes YES Y].freeze
    # Some string values that can be considered as +false+ (thank you dry-rb for inspiration).
    FALSE_VALUES = %w[0 off Off OFF f false False FALSE F n no No NO N].freeze

    MISSING_ERR = :missing

    NOT_GTE_ERR = :not_gte
    NOT_GT_ERR = :not_gt
    NOT_LTE_ERR = :not_lte
    NOT_LT_ERR = :not_lt
    NOT_INCLUDED_ERR = :not_included
    TOO_LONG_ERR = :too_long
    TOO_SHORT_ERR = :too_short

    NOT_BOOL_ERR = :not_bool
    NOT_DECIMAL_ERR = :not_decimal
    NOT_INTEGER_ERR = :not_integer
    NOT_STRING_ERR = :not_string

    # Verifies inclusion of a value in a collection.
    #
    # Verifies if value of the +option+ is included in the provided +collection+.
    INCLUDED_IN = lambda do |collection, option|
      collection.include?(option.value) ? Success.new(option) : Failure.new(NOT_INCLUDED_ERR)
    end.curry

    # Describes an optional value.
    #
    # If +option+ is the +Optiomist::None+ it succeeds causing the parameter not to be included in the final result.
    # Otherwise executes the funciton +fn+ for the option.
    OPTIONAL = lambda do |fn, option|
      case option
      in Optiomist::None
        Success.new(option)
      in Optiomist::Some
        fn.call(option)
      end
    end.curry

    # Describes a required value.
    #
    # It fails if +option+ is a +Optiomist::None+. Otherwise executes the funciton +fn+ for the option.
    REQUIRED = lambda do |fn, option|
      case option
      in Optiomist::None
        Failure.new(MISSING_ERR)
      in Optiomist::Some
        fn.call(option)
      end
    end.curry

    # Checks if the +option+'s value is greater than or equal to the provided +limit+.
    GTE = ->(limit, option) { option.value >= limit ? Success.new(option) : Failure.new(NOT_GTE_ERR) }.curry

    # Checks if the +option+'s value is greater than the provided +limit+.
    GT = ->(limit, option) { option.value > limit ? Success.new(option) : Failure.new(NOT_GT_ERR) }.curry

    # Checks if the +option+'s value is less than or equal to the provided +limit+.
    LTE = ->(limit, option) { option.value <= limit ? Success.new(option) : Failure.new(NOT_LTE_ERR) }.curry

    # Checks if the +option+'s value is less than the provided +limit+.
    LT = ->(limit, option) { option.value < limit ? Success.new(option) : Failure.new(NOT_LT_ERR) }.curry

    # Checks if the size of the value in +option+ does not exceed provided +limit+.
    MAX_SIZE = lambda do |limit, option|
      option.value.size <= limit ? Success.new(option) : Failure.new(TOO_LONG_ERR)
    end.curry

    # Checks if the size of the value in +option+ is not lower than the provided +limit+.
    MIN_SIZE = lambda do |limit, option|
      option.value.size >= limit ? Success.new(option) : Failure.new(TOO_SHORT_ERR)
    end.curry

    # Removes leading and trailing spaces from string provided in +option+'s value.
    STRIPPED = ->(option) { Success.new(Optiomist.some(option.value.strip)) }

    # Converts provided +option+'s value to integer.
    # If the conversion is not possible it fails.
    INTEGER = lambda do |option|
      begin
        integer_value = Integer(option.value)
      rescue StandardError
        return Failure.new(NOT_INTEGER_ERR)
      end
      Success.new(Optiomist.some(integer_value))
    end

    # Converts provided +option+'s value to float.
    # If the conversion is not possible it fails.
    DECIMAL = lambda do |option|
      begin
        float_value = Float(option.value)
      rescue StandardError
        return Failure.new(NOT_DECIMAL_ERR)
      end
      Success.new(Optiomist.some(float_value))
    end

    # Converts provided +option+'s value to boolean.
    # If the conversion is not possible it fails.
    BOOL = lambda do |option|
      case option
      in Optiomist::Some
        if [true, *TRUE_VALUES].include?(option.value)
          Success.new(Optiomist.some(true))
        elsif [false, *FALSE_VALUES].include?(option.value)
          Success.new(Optiomist.some(false))
        else
          Failure.new(NOT_BOOL_ERR)
        end
      in Optiomist::None
        Failure.new(NOT_BOOL_ERR)
      end
    end

    # Converts provided +option+'s value to string.
    # If the conversion is not possible it fails.
    STRING = lambda do |option|
      case option
      in Optiomist::Some
        Success.new(Optiomist.some(option.value.to_s))
      in Optiomist::None
        Failure.new(NOT_STRING_ERR)
      end
    end
  end
end
