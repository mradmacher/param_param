# frozen_string_literal: true

require 'test_helper'

describe ParamParam.min_size do
  let(:rules) do
    ParamParam.define.call(
      field: ParamParam.min_size.call(2),
    )
  end

  it 'accepts strings not shorter than required size' do
    params, errors = rules.call(field: '123')

    assert_predicate(errors, :empty?)
    assert_equal('123', params[:field])
  end

  it 'accepts strings with size equal to required size' do
    params, errors = rules.call(field: '12')

    assert_predicate(errors, :empty?)
    assert_equal('12', params[:field])
  end

  it 'rejects strings shorter than required size' do
    _, errors = rules.call(field: '1')

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::TOO_SHORT, errors[:field])
  end

  it 'accepts arrays not shorter than required size' do
    params, errors = rules.call(field: %w[1 2 3])

    assert_predicate(errors, :empty?)
    assert_equal(%w[1 2 3], params[:field])
  end

  it 'accepts arrays with size equal to required size' do
    params, errors = rules.call(field: %w[1 2])

    assert_predicate(errors, :empty?)
    assert_equal(%w[1 2], params[:field])
  end

  it 'rejects arrays shorter than required size' do
    _, errors = rules.call(field: %w[1])

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::TOO_SHORT, errors[:field])
  end
end
