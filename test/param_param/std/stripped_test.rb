# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std.stripped' do
  let(:rules) do
    PPX.define.(
      field: PPX.stripped,
    )
  end

  it 'removes leading and trailing spaces from string' do
    params, errors = rules.call(field: ' the  core   ')

    assert_predicate(errors, :empty?)
    assert_equal('the  core', params[:field])
  end
end
