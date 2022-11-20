# frozen_string_literal: true

require 'test_helper'

describe ParamParam::IsBool do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::IsBool.call(ParamParam::Any)
    )
  end

  it 'complains when field missing' do
    result = rules.call({})

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_BOOL, result.error[:field])
  end

  it 'complains for nil' do
    result = rules.call(field: nil)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_BOOL, result.error[:field])
  end

  it 'complains for None' do
    result = rules.call(field: ParamParam::Option.None)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_BOOL, result.error[:field])
  end

  it 'is true for true' do
    result = rules.call(field: true)

    assert_predicate(result, :success?)
    assert(result.value[:field])
  end

  it 'is false for false' do
    result = rules.call(field: false)

    assert_predicate(result, :success?)
    refute(result.value[:field])
  end

  it 'is true for values that are expected to be true' do
    %w[1 on On ON t true True TRUE T y yes Yes YES Y].each do |value|
      result = rules.call(field: value)

      assert_predicate(result, :success?, "expected #{value} to convert to bool")
      assert(result.value[:field], "expected #{value} to be true")
    end
  end

  it 'is false for values that are expected to be false' do
    %w[0 off Off OFF f false False FALSE F n no No NO N].each do |value|
      result = rules.call(field: value)

      assert_predicate(result, :success?, "expected #{value} to convert to bool")
      refute(result.value[:field], "expected #{value} to be false")
    end
  end
end
