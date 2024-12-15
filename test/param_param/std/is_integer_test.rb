# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::INTEGER' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::INTEGER,
      }
    end
  end

  it 'complains when field missing' do
    _, errors = actions.call({})

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_INTEGER_ERR, errors[:field])
  end

  it 'complains for nil' do
    _, errors = actions.call(field: nil)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_INTEGER_ERR, errors[:field])
  end

  it 'complains for None' do
    _, errors = actions.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_INTEGER_ERR, errors[:field])
  end

  it 'accepts integer values' do
    params, errors = actions.call(field: 4)

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'accepts integer values passed as strings' do
    params, errors = actions.call(field: '4')

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'accepts integer values passed as strings with spaces' do
    params, errors = actions.call(field: '   4   ')

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'complains for strings not convertable to integer' do
    _, errors = actions.call(field: '4.0')

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_INTEGER_ERR, errors[:field])

    _, errors = actions.call(field: '4 apples')

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_INTEGER_ERR, errors[:field])
  end
end
