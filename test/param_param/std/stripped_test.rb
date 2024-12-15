# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::STRIPPED' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::STRIPPED,
      }
    end
  end

  it 'removes leading and trailing spaces from string' do
    params, errors = actions.call(field: ' the  core   ')

    assert_predicate(errors, :empty?)
    assert_equal('the  core', params[:field])
  end
end
