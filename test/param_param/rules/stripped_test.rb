# frozen_string_literal: true

require 'test_helper'

describe ParamParam::BlankToNilOr do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::Stripped
    )
  end

  it 'removes leading and trailing spaces from string' do
    result = rules.call(field: ' the  core   ')

    assert_predicate result, :success?
    assert_equal 'the  core', result.value[:field]
  end
end
