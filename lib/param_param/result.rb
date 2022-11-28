# frozen_string_literal: true

module ParamParam
  # Defines operation result pattern.
  # A result can be a success or a failure and has some value.
  class Result
    # Returns +false+.
    def success?
      false
    end

    # Returns +false+.
    def failure?
      false
    end
  end

  # Describes successful result.
  class Success < Result
    # A value related to the success.
    attr_reader :value

    def initialize(value)
      @value = value
    end

    # Returns +true+.
    def success?
      true
    end
  end

  # Describes failed result.
  class Failure < Result
    # An error related to the failure.
    attr_reader :error

    def initialize(error)
      @error = error
    end

    # Returns +true+.
    def failure?
      true
    end
  end
end
