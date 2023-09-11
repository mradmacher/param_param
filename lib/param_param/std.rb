# frozen_string_literal: true

# It contains a collection of some useful rules.
module ParamParam
  # Some string values that can be considered as +true+ (thank you dry-rb for inspiration).
  TRUE_VALUES = %w[1 on On ON t true True TRUE T y yes Yes YES Y].freeze
  # Some string values that can be considered as +false+ (thank you dry-rb for inspiration).
  FALSE_VALUES = %w[0 off Off OFF f false False FALSE F n no No NO N].freeze

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

  # Verifies inclusion of a value in a collection.
  #
  # Returns
  #  lambda { |collection, option| ... }.
  #
  # Verifies if value of the +option+ is included in the provided +collection+.
  def self.included_in
    lambda { |collection, option|
      collection.include?(option.value) ? Success.new(option) : Failure.new(NOT_INCLUDED)
    }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the +option+'s value is greater than or equal to the provided +limit+.
  def self.gte
    ->(limit, option) { option.value >= limit ? Success.new(option) : Failure.new(NOT_GTE) }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the +option+'s value is greater than the provided +limit+.
  def self.gt
    ->(limit, option) { option.value > limit ? Success.new(option) : Failure.new(NOT_GT) }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the +option+'s value is less than or equal to the provided +limit+.
  def self.lte
    ->(limit, option) { option.value <= limit ? Success.new(option) : Failure.new(NOT_LTE) }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the +option+'s value is less than the provided +limit+.
  def self.lt
    ->(limit, option) { option.value < limit ? Success.new(option) : Failure.new(NOT_LT) }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the size of the value in +option+ does not exceed provided +limit+.
  def self.max_size
    lambda { |limit, option|
      option.value.size <= limit ? Success.new(option) : Failure.new(TOO_LONG)
    }.curry
  end

  # Returns
  #  lambda { |limit, option| ... }.
  #
  # Checks if the size of the value in +option+ is not lower than the provided +limit+.
  def self.min_size
    lambda { |limit, option|
      option.value.size >= limit ? Success.new(option) : Failure.new(TOO_SHORT)
    }.curry
  end

  # Returns
  #  lambda { |option| ... }.
  #
  # Removes leading and trailing spaces from string provided in +option+'s value.
  def self.stripped
    ->(option) { Success.new(Optiomist.some(option.value.strip)) }
  end

  # Returns
  #  lambda { |fn, option| ... }.
  #
  # Converts provided +option+'s value to integer.
  # If the conversion is not possible it fails, otherwise executes the provider function +fn+
  # for the converted integer value.
  def self.integer
    lambda { |fn, option|
      begin
        integer_value = Integer(option.value)
      rescue StandardError
        return Failure.new(NON_INTEGER)
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
  def self.decimal
    lambda { |fn, option|
      begin
        float_value = Float(option.value)
      rescue StandardError
        return Failure.new(NON_DECIMAL)
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
  def self.bool
    lambda { |fn, option|
      case option
      in Optiomist::Some
        if [true, *TRUE_VALUES].include?(option.value)
          fn.call(Optiomist.some(true))
        elsif [false, *FALSE_VALUES].include?(option.value)
          fn.call(Optiomist.some(false))
        else
          Failure.new(NON_BOOL)
        end
      in Optiomist::None
        Failure.new(NON_BOOL)
      end
    }.curry
  end

  # Returns
  #  lambda { |fn, option| ... }.
  #
  # Converts provided +option+'s value to string.
  # If the conversion is not possible it fails, otherwise executes the provider function +fn+
  # for the converted string value.
  def self.string
    lambda { |fn, option|
      case option
      in Optiomist::Some
        fn.call(Optiomist.some(option.value.to_s))
      in Optiomist::None
        Failure.new(NON_STRING)
      end
    }.curry
  end
end
