# frozen_string_literal: true

require 'test_helper'

describe ParamParam::Std::BlankToNilOr do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::Std::Stripped,
    )
  end

  it 'removes leading and trailing spaces from string' do
    params, errors = rules.call(field: ' the  core   ')

    assert_predicate(errors, :empty?)
    assert_equal('the  core', params[:field])
  end
end
