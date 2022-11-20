# frozen_string_literal: true

require 'test_helper'

describe ParamParam::MaxSize do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::MaxSize.call(10)
    )
  end

  it 'accepts strings not longer than required size' do
    result = rules.call(field: '0123456789')

    assert_predicate result, :success?
    assert_equal '0123456789', result.value[:field]
  end

  it 'rejects strings longer than required size' do
    result = rules.call(field: '12345678910')

    assert_predicate result, :failure?
    assert_equal ParamParam::TOO_LONG, result.error[:field]
  end

  it 'accepts arrays not longer than required size' do
    result = rules.call(field: %w[0 1 2 3 4 5 6 7 8 9])

    assert_predicate result, :success?
    assert_equal %w[0 1 2 3 4 5 6 7 8 9], result.value[:field]
  end

  it 'rejects arrays longer than required size' do
    result = rules.call(field: %w[0 1 2 3 4 5 6 7 8 9 10])

    assert_predicate result, :failure?
    assert_equal ParamParam::TOO_LONG, result.error[:field]
  end
end
