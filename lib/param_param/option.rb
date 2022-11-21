# frozen_string_literal: true

require 'singleton'

module ParamParam
  module Option
    class Some
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def some?
        true
      end

      def none?
        false
      end
    end

    class None
      include Singleton

      def nil?
        true
      end

      def some?
        false
      end

      def none?
        true
      end
    end

    def self.Some(value)
      Option::Some.new(value)
    end

    def self.None
      Option::None.instance
    end
  end
end
