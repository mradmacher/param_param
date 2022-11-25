# frozen_string_literal: true

require 'singleton'

module ParamParam
  # Defines option pattern.
  module Option
    # There is some value.
    # +nil+ is also treated as a value.
    class Some
      # This is some value.
      attr_reader :value

      def initialize(value)
        @value = value
      end

      # It's +true+.
      def some?
        true
      end

      # It's +false+.
      def none?
        false
      end
    end

    # There is no value.
    class None
      include Singleton

      # Should it really respond to +nil?+
      def nil?
        true
      end

      # It's +false+.
      def some?
        false
      end

      # It's +true+.
      def none?
        true
      end
    end

    # A shortcut to create +Option::Some+ for given +value+.
    def self.Some(value)
      Option::Some.new(value)
    end

    # A shortcut to get +Option::None+.
    def self.None
      Option::None.instance
    end
  end
end
