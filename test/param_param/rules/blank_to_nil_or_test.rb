# frozen_string_literal: true

require 'test_helper'

describe ParamParam::BlankToNilOr do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::BlankToNilOr.call(ParamParam::Any)
    )
  end

  it 'convert empty string to nil' do
    result = rules.call(field: '')

    assert_predicate(result, :success?)
    assert_nil(result.value[:field])
  end

  it 'convert string with blanks to nil' do
    result = rules.call(field: '   ')

    assert_predicate(result, :success?)
    assert_nil(result.value[:field])
  end

  it 'convert nil to nil' do
    result = rules.call(field: nil)

    assert_predicate(result, :success?)
    assert_nil(result.value[:field])
  end

  it 'passes to next conversion for not blank values' do
    result = rules.call(field: 666)

    assert_predicate(result, :success?)
    assert_equal(666, result.value[:field])
  end
end
