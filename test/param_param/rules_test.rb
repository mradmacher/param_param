# frozen_string_literal: true

require 'test_helper'

describe ParamParam do
  describe ParamParam::Required do
    let(:rules) do
      ParamParam::Rules.call(
        field: ParamParam::Required.call(ParamParam::Any)
      )
    end

    it 'fails when value is None' do
      result = rules.call(field: ParamParam::Option.None)

      assert_predicate result, :failure?
      assert_equal :missing, result.error[:field]
    end

    it 'fails when field is missing' do
      result = rules.call(other_field: 'some value')

      assert_predicate result, :failure?
      assert_equal :missing, result.error[:field]
    end

    it 'succeeds when value is nil' do
      result = rules.call(field: nil)

      assert_predicate result, :success?
      assert_nil result.value[:field]
    end
  end

  describe ParamParam::Optional do
    let(:rules) do
      ParamParam::Rules.call(
        field: ParamParam::Optional.call(ParamParam::Any)
      )
    end

    it 'succeeds when value is None' do
      result = rules.call(field: ParamParam::Option.None)

      assert_predicate result, :success?
      refute result.value.key?(:field)
    end

    it 'succeeds when field is missing' do
      result = rules.call(other_field: 'some value')

      assert_predicate result, :success?
      refute result.value.key?(:field)
    end

    it 'succeeds when value is nil' do
      result = rules.call(field: nil)

      assert_predicate result, :success?
      assert_nil result.value[:field]
    end

    it 'succeeds when value is present' do
      result = rules.call(field: 'some value')

      assert_predicate result, :success?
      assert_equal 'some value', result.value[:field]
    end
  end
end
