# frozen_string_literal: true

require 'test_helper'

describe ParamParam::IsDecimal do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::IsDecimal.call(ParamParam::Any)
    )
  end

  it 'complains when field missing' do
    result = rules.call({})

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_DECIMAL, result.error[:field])
  end

  it 'complains for nil' do
    result = rules.call(field: nil)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_DECIMAL, result.error[:field])
  end

  it 'complains for None' do
    result = rules.call(field: ParamParam::Option.None)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NON_DECIMAL, result.error[:field])
  end

  it 'accepts decimal values' do
    result = rules.call(field: 1.23)

    assert_predicate(result, :success?)
    assert_in_delta(1.23, result.value[:field])
  end

  it 'accepts decimal values provided as strings' do
    result = rules.call(field: ' 1.23 ')

    assert_predicate(result, :success?)
    assert_in_delta(1.23, result.value[:field])
  end
end
