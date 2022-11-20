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

  Optional = lambda { |fn, v|
    case v
    in Option::None
      Success.new(v)
    in Option::Some
      fn.call(v)
    end
  }.curry

  Required = lambda { |fn, v|
    case v
    in Option::None
      Failure.new(MISSING)
    in Option::Some
      fn.call(v)
    end
  }.curry

  IncludedIn = lambda { |collection, v|
    collection.include?(v.value) ? Success.new(v) : Failure.new(NOT_INCLUDED)
  }.curry

  BlankToNilOr = lambda { |fn, v|
    v.value.nil? || (v.value.is_a?(String) && v.value.strip.empty?) ? Success.new(Option.Some(nil)) : fn.call(v)
  }.curry

  NotBlank = lambda { |v|
    v.value.nil? || (v.value.is_a?(String) && v.value.strip.empty?) ? Failure.new(BLANK) : Success.new(v)
  }

  Any = ->(v) { Success.new(v) }

  Gte = ->(limit, v) { v.value >= limit ? Success.new(v) : Failure.new(NOT_GTE) }.curry

  Gt = ->(limit, v) { v.value > limit ? Success.new(v) : Failure.new(NOT_GT) }.curry

  Lte = ->(limit, v) { v.value <= limit ? Success.new(v) : Failure.new(NOT_LTE) }.curry

  Lt = ->(limit, v) { v.value < limit ? Success.new(v) : Failure.new(NOT_LT) }.curry

  MaxSize = lambda { |limit, v|
    v.value.size <= limit ? Success.new(v) : Failure.new(TOO_LONG)
  }.curry

  Stripped = lambda { |v|
    Success.new(Option.Some(v.value.strip))
  }

  IsInteger = lambda { |fn, v|
    begin
      result = Integer(v.value)
    rescue StandardError
      return Failure.new(NON_INTEGER)
    end
    fn.call(Option.Some(result))
  }.curry

  IsDecimal = lambda { |fn, v|
    begin
      result = Float(v.value)
    rescue StandardError
      return Failure.new(NON_DECIMAL)
    end
    fn.call(Option.Some(result))
  }.curry

  IsBool = lambda { |fn, v|
    case v
    in Option::Some
      if [true, *TRUE_VALUES].include?(v.value)
        fn.call(Option.Some(true))
      elsif [false, *FALSE_VALUES].include?(v.value)
        fn.call(Option.Some(false))
      else
        Failure.new(NON_BOOL)
      end
    in Option::None
      Failure.new(NON_BOOL)
    end
  }.curry

  IsString = lambda { |fn, v|
    if v.is_a?(Option::Some)
      fn.call(Option.Some(v.value.to_s))
    else
      Failure.new(NON_STRING)
    end
  }.curry
end
