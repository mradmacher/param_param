# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std.required' do
  let(:rules) do
    PPX.define.(
      field: PPX.required.(PPX.any),
    )
  end

  it 'fails when value is None' do
    _, errors = rules.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::MISSING, errors[:field])
  end

  it 'fails when field is missing' do
    _, errors = rules.call(other_field: 'some value')

    refute_predicate(errors, :empty?)
    assert_equal(PPX::MISSING, errors[:field])
  end

  it 'succeeds when value is nil' do
    params, errors = rules.call(field: nil)

    assert_predicate(errors, :empty?)
    assert_nil(params[:field])
  end
end
