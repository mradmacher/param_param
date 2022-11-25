# frozen_string_literal: true

module ParamParam
  # Defines operation result pattern.
  # A result can be a success or a failure and has some value.
  module Result
    # Describes successful result.
    class Success
      # A value related to the success.
      attr_reader :value

      def initialize(value)
        @value = value
      end

      # Returns +true+.
      def success?
        true
      end

      # Returns +false+.
      def failure?
        false
      end
    end

    # Describes failed result.
    class Failure
      # An error related to the failure.
      attr_reader :error

      def initialize(error)
        @error = error
      end

      # Returns +false+.
      def success?
        false
      end

      # Returns +true+.
      def failure?
        true
      end
    end
  end
end
