# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::MAX_SIZE' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::MAX_SIZE.(10),
      }
    end
  end

  it 'accepts strings not longer than required size' do
    params, errors = actions.call(field: '123456789')

    assert_predicate(errors, :empty?)
    assert_equal('123456789', params[:field])
  end

  it 'accepts strings with size equal to required size' do
    params, errors = actions.call(field: '0123456789')

    assert_predicate(errors, :empty?)
    assert_equal('0123456789', params[:field])
  end

  it 'rejects strings longer than required size' do
    _, errors = actions.call(field: '12345678910')

    refute_predicate(errors, :empty?)
    assert_equal(PPX::TOO_LONG_ERR, errors[:field])
  end

  it 'accepts arrays not longer than required size' do
    params, errors = actions.call(field: %w[1 2 3 4 5 6 7 8 9])

    assert_predicate(errors, :empty?)
    assert_equal(%w[1 2 3 4 5 6 7 8 9], params[:field])
  end

  it 'accepts arrays with size equal to required size' do
    params, errors = actions.call(field: %w[0 1 2 3 4 5 6 7 8 9])

    assert_predicate(errors, :empty?)
    assert_equal(%w[0 1 2 3 4 5 6 7 8 9], params[:field])
  end

  it 'rejects arrays longer than required size' do
    _, errors = actions.call(field: %w[0 1 2 3 4 5 6 7 8 9 10])

    refute_predicate(errors, :empty?)
    assert_equal(PPX::TOO_LONG_ERR, errors[:field])
  end
end
