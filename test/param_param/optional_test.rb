# frozen_string_literal: true

require 'test_helper'

describe ParamParam.optional do
  let(:rules) do
    ParamParam.define.call(
      field: ParamParam.optional.call(ParamParam.any),
    )
  end

  it 'succeeds when value is None' do
    params, errors = rules.call(field: Optiomist.none)

    assert_predicate(errors, :empty?)
    refute(params.key?(:field))
  end

  it 'succeeds when field is missing' do
    params, errors = rules.call(other_field: 'some value')

    assert_predicate(errors, :empty?)
    refute(params.key?(:field))
  end

  it 'succeeds when value is nil' do
    params, errors = rules.call(field: nil)

    assert_predicate(errors, :empty?)
    assert(params.key?(:field))
    assert_nil(params[:field])
  end

  it 'succeeds when value is present' do
    params, errors = rules.call(field: 'some value')

    assert_predicate(errors, :empty?)
    assert_equal('some value', params[:field])
  end
end
