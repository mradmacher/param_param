# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::DECIMAL' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::DECIMAL,
      }
    end
  end

  it 'complains when field missing' do
    _, errors = actions.call({})

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_DECIMAL_ERR, errors[:field])
  end

  it 'complains for nil' do
    _, errors = actions.call(field: nil)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_DECIMAL_ERR, errors[:field])
  end

  it 'complains for None' do
    _, errors = actions.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_DECIMAL_ERR, errors[:field])
  end

  it 'accepts decimal values' do
    params, errors = actions.call(field: 1.23)

    assert_predicate(errors, :empty?)
    assert_in_delta(1.23, params[:field])
  end

  it 'accepts decimal values provided as strings' do
    params, errors = actions.call(field: ' 1.23 ')

    assert_predicate(errors, :empty?)
    assert_in_delta(1.23, params[:field])
  end
end
