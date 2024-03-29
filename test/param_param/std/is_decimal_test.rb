# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std.decimal' do
  let(:rules) do
    PPX.define.(
      field: PPX.decimal.(PPX.any),
    )
  end

  it 'complains when field missing' do
    _, errors = rules.call({})

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NON_DECIMAL, errors[:field])
  end

  it 'complains for nil' do
    _, errors = rules.call(field: nil)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NON_DECIMAL, errors[:field])
  end

  it 'complains for None' do
    _, errors = rules.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NON_DECIMAL, errors[:field])
  end

  it 'accepts decimal values' do
    params, errors = rules.call(field: 1.23)

    assert_predicate(errors, :empty?)
    assert_in_delta(1.23, params[:field])
  end

  it 'accepts decimal values provided as strings' do
    params, errors = rules.call(field: ' 1.23 ')

    assert_predicate(errors, :empty?)
    assert_in_delta(1.23, params[:field])
  end
end
