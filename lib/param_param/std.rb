# frozen_string_literal: true

module ParamParam
  # It defines some functions that can be useful in everyday life to define rules.
  module Std
    def self.included(base)
      base.include(Messages)
      base.extend(Functions)
    end

    # Some string values that can be considered as +true+ (thank you dry-rb for inspiration).
    TRUE_VALUES = %w[1 on On ON t true True TRUE T y yes Yes YES Y].freeze
    # Some string values that can be considered as +false+ (thank you dry-rb for inspiration).
    FALSE_VALUES = %w[0 off Off OFF f false False FALSE F n no No NO N].freeze

    # Validation messages for rules.
    module Messages
      BLANK = :blank
      MISSING = :missing

      NOT_GTE = :not_gte
      NOT_GT = :not_gt
      NOT_LTE = :not_lte
      NOT_LT = :not_lt
      NOT_INCLUDED = :not_included
      TOO_LONG = :too_long
      TOO_SHORT = :too_short

      NON_BOOL = :non_bool
      NON_DECIMAL = :non_decimal
      NON_INTEGER = :non_integer
      NON_STRING = :non_string
    end

    # Functions definitions.
    module Functions
      # Verifies inclusion of a value in a collection.
      #
      # Returns
      #  lambda { |collection, option| ... }.
      #
      # Verifies if value of the +option+ is included in the provided +collection+.
      def included_in
        lambda { |collection, option|
          collection.include?(option.value) ? Success.new(option) : Failure.new(Messages::NOT_INCLUDED)
        }.curry
      end

      # Describes an optional value.
      #
      # Returns
      #  lambda { |fn, option| ... }.
      #
      # If +option+ is the +Optiomist::None+ it succeeds causing the parameter not to be included in the final result.
      # Otherwise executes the funciton +fn+ for the option.
      def optional
        lambda { |fn, option|
          case option
          in Optiomist::None
            Success.new(option)
          in Optiomist::Some
            fn.call(option)
          end
        }.curry
      end

      # Describes a required value.
      #
      # Returns
      #  lambda { |fn, option| ... }.
      #
      # If +option+ is a +Optiomist::None+ it fails otherwise executes the funciton +fn+ for the option.
      def required
        lambda { |fn, option|
          case option
          in Optiomist::None
            Failure.new(Messages::MISSING)
          in Optiomist::Some
            fn.call(option)
          end
        }.curry
      end

      # Converts blank value to nil or passes non blank value to next rule.
      #
      # Returns
      #  lambda { |fn, option| ... }.
      #
      # If provided +option+'s value is blank it succeeds with +nil+
      # otherwise executes provided function for the +option+.
      def blank_to_nil_or
        lambda { |fn, option|
          blank?(option.value) ? Success.new(Optiomist.some(nil)) : fn.call(option)
        }.curry
      end

      # Verifies if value is not blank.
      #
      # Returns
      #  lambda { |option| ... }.
      #
      # It fails if provided +option+ is blank, otherwise succeeds with the +option+.
      def not_blank
        ->(option) { blank?(option.value) ? Failure.new(Messages::BLANK) : Success.new(option) }
      end

      # Verifies if provided value is nil, empty string or string consisting only from spaces.
      def blank?(value)
        value.nil? || (value.is_a?(String) && value.strip.empty?)
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the +option+'s value is greater than or equal to the provided +limit+.
      def gte
        ->(limit, option) { option.value >= limit ? Success.new(option) : Failure.new(Messages::NOT_GTE) }.curry
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the +option+'s value is greater than the provided +limit+.
      def gt
        ->(limit, option) { option.value > limit ? Success.new(option) : Failure.new(Messages::NOT_GT) }.curry
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the +option+'s value is less than or equal to the provided +limit+.
      def lte
        ->(limit, option) { option.value <= limit ? Success.new(option) : Failure.new(Messages::NOT_LTE) }.curry
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the +option+'s value is less than the provided +limit+.
      def lt
        ->(limit, option) { option.value < limit ? Success.new(option) : Failure.new(Messages::NOT_LT) }.curry
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the size of the value in +option+ does not exceed provided +limit+.
      def max_size
        lambda { |limit, option|
          option.value.size <= limit ? Success.new(option) : Failure.new(Messages::TOO_LONG)
        }.curry
      end

      # Returns
      #  lambda { |limit, option| ... }.
      #
      # Checks if the size of the value in +option+ is not lower than the provided +limit+.
      def min_size
        lambda { |limit, option|
          option.value.size >= limit ? Success.new(option) : Failure.new(Messages::TOO_SHORT)
        }.curry
      end

      # Returns
      #  lambda { |option| ... }.
      #
      # Removes leading and trailing spaces from string provided in +option+'s value.
      def stripped
        ->(option) { Success.new(Optiomist.some(option.value.strip)) }
      end

      # Returns
      #  lambda { |fn, option| ... }.
      #
      # Converts provided +option+'s value to integer.
      # If the conversion is not possible it fails, otherwise executes the provider function +fn+
      # for the converted integer value.
      def integer
        lambda { |fn, option|
          begin
            integer_value = Integer(option.value)
          rescue StandardError
            return Failure.new(Messages::NON_INTEGER)
          end
          fn.call(Optiomist.some(integer_value))
        }.curry
      end

      # Returns
      #  lambda { |fn, option| ... }.
      #
      # Converts provided +option+'s value to float.
      # If the conversion is not possible it fails, otherwise executes the provider function +fn+
      # for the converted float value.
      def decimal
        lambda { |fn, option|
          begin
            float_value = Float(option.value)
          rescue StandardError
            return Failure.new(Messages::NON_DECIMAL)
          end
          fn.call(Optiomist.some(float_value))
        }.curry
      end

      # Returns
      #  lambda { |fn, option| ... }.
      #
      # Converts provided +option+'s value to boolean.
      # If the conversion is not possible it fails, otherwise executes the provider function +fn+
      # for the converted boolean value.
      def bool
        lambda { |fn, option|
          case option
          in Optiomist::Some
            if [true, *TRUE_VALUES].include?(option.value)
              fn.call(Optiomist.some(true))
            elsif [false, *FALSE_VALUES].include?(option.value)
              fn.call(Optiomist.some(false))
            else
              Failure.new(Messages::NON_BOOL)
            end
          in Optiomist::None
            Failure.new(Messages::NON_BOOL)
          end
        }.curry
      end

      # Returns
      #  lambda { |fn, option| ... }.
      #
      # Converts provided +option+'s value to string.
      # If the conversion is not possible it fails, otherwise executes the provider function +fn+
      # for the converted string value.
      def string
        lambda { |fn, option|
          case option
          in Optiomist::Some
            fn.call(Optiomist.some(option.value.to_s))
          in Optiomist::None
            Failure.new(Messages::NON_STRING)
          end
        }.curry
      end
    end
  end
end
