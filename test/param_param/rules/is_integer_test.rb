# frozen_string_literal: true

require 'test_helper'

describe ParamParam::IsInteger do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::IsInteger.call(ParamParam::Any)
    )
  end

  it 'complains when field missing' do
    result = rules.call({})

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_INTEGER, result.error[:field])
  end

  it 'complains for nil' do
    result = rules.call(field: nil)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_INTEGER, result.error[:field])
  end

  it 'complains for None' do
    result = rules.call(field: ParamParam::Option.None)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_INTEGER, result.error[:field])
  end

  it 'accepts integer values' do
    result = rules.call(field: 4)

    assert_predicate(result, :success?)
    assert_equal(4, result.value[:field])
  end

  it 'accepts integer values passed as strings' do
    result = rules.call(field: '4')

    assert_predicate(result, :success?)
    assert_equal(4, result.value[:field])
  end

  it 'accepts integer values passed as strings with spaces' do
    result = rules.call(field: '   4   ')

    assert_predicate(result, :success?)
    assert_equal(4, result.value[:field])
  end

  it 'complains for strings not convertable to integer' do
    result = rules.call(field: '4.0')

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_INTEGER, result.error[:field])

    result = rules.call(field: '4 apples')

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_INTEGER, result.error[:field])
  end
end
