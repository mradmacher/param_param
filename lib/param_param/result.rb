# frozen_string_literal: true

module ParamParam
  class Result
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def failure?
      false
    end

    def success?
      false
    end
  end

  class Success < Result
    def success?
      true
    end
  end

  class Failure < Result
    def failure?
      true
    end

    def error
      @value
    end

    def value
      raise '`value` does not exist for failure'
    end
  end
end
