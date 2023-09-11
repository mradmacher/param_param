# frozen_string_literal: true

require 'test_helper'

describe ParamParam.integer do
  let(:rules) do
    ParamParam.define.call(
      field: ParamParam.integer.call(ParamParam.any),
    )
  end

  it 'complains when field missing' do
    _, errors = rules.call({})

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NON_INTEGER, errors[:field])
  end

  it 'complains for nil' do
    _, errors = rules.call(field: nil)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NON_INTEGER, errors[:field])
  end

  it 'complains for None' do
    _, errors = rules.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NON_INTEGER, errors[:field])
  end

  it 'accepts integer values' do
    params, errors = rules.call(field: 4)

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'accepts integer values passed as strings' do
    params, errors = rules.call(field: '4')

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'accepts integer values passed as strings with spaces' do
    params, errors = rules.call(field: '   4   ')

    assert_predicate(errors, :empty?)
    assert_equal(4, params[:field])
  end

  it 'complains for strings not convertable to integer' do
    _, errors = rules.call(field: '4.0')

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NON_INTEGER, errors[:field])

    _, errors = rules.call(field: '4 apples')

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NON_INTEGER, errors[:field])
  end
end
