# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::MIN_SIZE' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::MIN_SIZE.(2),
      }
    end
  end

  it 'accepts strings not shorter than required size' do
    params, errors = actions.call(field: '123')

    assert_predicate(errors, :empty?)
    assert_equal('123', params[:field])
  end

  it 'accepts strings with size equal to required size' do
    params, errors = actions.call(field: '12')

    assert_predicate(errors, :empty?)
    assert_equal('12', params[:field])
  end

  it 'rejects strings shorter than required size' do
    _, errors = actions.call(field: '1')

    refute_predicate(errors, :empty?)
    assert_equal(PPX::TOO_SHORT_ERR, errors[:field])
  end

  it 'accepts arrays not shorter than required size' do
    params, errors = actions.call(field: %w[1 2 3])

    assert_predicate(errors, :empty?)
    assert_equal(%w[1 2 3], params[:field])
  end

  it 'accepts arrays with size equal to required size' do
    params, errors = actions.call(field: %w[1 2])

    assert_predicate(errors, :empty?)
    assert_equal(%w[1 2], params[:field])
  end

  it 'rejects arrays shorter than required size' do
    _, errors = actions.call(field: %w[1])

    refute_predicate(errors, :empty?)
    assert_equal(PPX::TOO_SHORT_ERR, errors[:field])
  end
end
