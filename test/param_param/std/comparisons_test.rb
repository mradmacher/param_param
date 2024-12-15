# frozen_string_literal: true

require 'test_std_helper'

describe 'Comparisons' do
  let(:actions) do
    PPX.define do |p|
      {
        field_gte: p::GTE.(0),
        field_gt: p::GT.(0),
        field_lte: p::LTE.(0),
        field_lt: p::LT.(0),
      }
    end
  end

  it 'returns integers when fulfill condition' do
    params, errors = actions.call(
      field_gte: 0,
      field_gt: 1,
      field_lte: 0,
      field_lt: -1,
    )

    assert_predicate(errors, :empty?)
    assert_equal(0, params[:field_gte])
    assert_equal(1, params[:field_gt])
    assert_equal(0, params[:field_lte])
    assert_equal(-1, params[:field_lt])
  end

  it 'returns decimals when fulfill condition' do
    params, errors = actions.call(
      field_gte: 0.0,
      field_gt: 1.0,
      field_lte: 0.0,
      field_lt: -1.0,
    )

    assert_predicate(errors, :empty?)
    assert_in_delta(0.0, params[:field_gte])
    assert_in_delta(1.0, params[:field_gt])
    assert_in_delta(0.0, params[:field_lte])
    assert_in_delta(-1.0, params[:field_lt])
  end

  it 'returns errors when conditions not fulfilled' do
    _, errors = actions.call(
      field_gte: -1,
      field_gt: 0,
      field_lte: 1,
      field_lt: 0,
    )

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_GTE_ERR, errors[:field_gte])
    assert_equal(PPX::NOT_GT_ERR, errors[:field_gt])
    assert_equal(PPX::NOT_LTE_ERR, errors[:field_lte])
    assert_equal(PPX::NOT_LT_ERR, errors[:field_lt])
  end
end
