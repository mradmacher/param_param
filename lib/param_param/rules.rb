# frozen_string_literal: true

module ParamParam
  TRUE_VALUES = %w[1 on On ON t true True TRUE T y yes Yes YES Y].freeze
  FALSE_VALUES = %w[0 off Off OFF f false False FALSE F n no No NO N].freeze

  BLANK = :blank
  MISSING = :missing
  NOT_GTE = :not_gte
  NOT_GT = :not_gt
  NOT_LTE = :not_lte
  NOT_LT = :not_lt
  NOT_INCLUDED = :not_included
  TOO_LONG = :too_long

  NON_BOOL = :non_bool
  NON_DECIMAL = :non_decimal
  NON_INTEGER = :non_integer
  NON_STRING = :non_string

  Optional = lambda { |fn, option|
    case option
    in Option::None
      Success.new(option)
    in Option::Some
      fn.call(option)
    end
  }.curry

  Required = lambda { |fn, option|
    case option
    in Option::None
      Failure.new(MISSING)
    in Option::Some
      fn.call(option)
    end
  }.curry

  IncludedIn = lambda { |collection, option|
    collection.include?(option.value) ? Success.new(option) : Failure.new(NOT_INCLUDED)
  }.curry

  BlankToNilOr = lambda { |fn, option|
    blank?(option.value) ? Success.new(Option.Some(nil)) : fn.call(option)
  }.curry

  NotBlank = lambda { |option|
    blank?(option.value) ? Failure.new(BLANK) : Success.new(option)
  }

  Any = ->(option) { Success.new(option) }

  Gte = ->(limit, option) { option.value >= limit ? Success.new(option) : Failure.new(NOT_GTE) }.curry

  Gt = ->(limit, option) { option.value > limit ? Success.new(option) : Failure.new(NOT_GT) }.curry

  Lte = ->(limit, option) { option.value <= limit ? Success.new(option) : Failure.new(NOT_LTE) }.curry

  Lt = ->(limit, option) { option.value < limit ? Success.new(option) : Failure.new(NOT_LT) }.curry

  MaxSize = lambda { |limit, option|
    option.value.size <= limit ? Success.new(option) : Failure.new(TOO_LONG)
  }.curry

  Stripped = lambda { |option|
    Success.new(Option.Some(option.value.strip))
  }

  IsInteger = lambda { |fn, option|
    begin
      integer_value = Integer(option.value)
    rescue StandardError
      return Failure.new(NON_INTEGER)
    end
    fn.call(Option.Some(integer_value))
  }.curry

  IsDecimal = lambda { |fn, option|
    begin
      float_value = Float(option.value)
    rescue StandardError
      return Failure.new(NON_DECIMAL)
    end
    fn.call(Option.Some(float_value))
  }.curry

  IsBool = lambda { |fn, option|
    case option
    in Option::Some
      if [true, *TRUE_VALUES].include?(option.value)
        fn.call(Option.Some(true))
      elsif [false, *FALSE_VALUES].include?(option.value)
        fn.call(Option.Some(false))
      else
        Failure.new(NON_BOOL)
      end
    in Option::None
      Failure.new(NON_BOOL)
    end
  }.curry

  IsString = lambda { |fn, option|
    case option
    in Option::Some
      fn.call(Option.Some(option.value.to_s))
    in Option::None
      Failure.new(NON_STRING)
    end
  }.curry

  def self.blank?(value)
    value.nil? || (value.is_a?(String) && value.strip.empty?)
  end
end
