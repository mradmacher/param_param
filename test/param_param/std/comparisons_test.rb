# frozen_string_literal: true

require 'test_std_helper'

describe 'Comparisons' do
  let(:rules) do
    PPX.define.(
      field_gte: PPX.gte.(0),
      field_gt: PPX.gt.(0),
      field_lte: PPX.lte.(0),
      field_lt: PPX.lt.(0),
    )
  end

  it 'returns integers when fulfill condition' do
    params, errors = rules.call(
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
    params, errors = rules.call(
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
    _, errors = rules.call(
      field_gte: -1,
      field_gt: 0,
      field_lte: 1,
      field_lt: 0,
    )

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_GTE, errors[:field_gte])
    assert_equal(PPX::NOT_GT, errors[:field_gt])
    assert_equal(PPX::NOT_LTE, errors[:field_lte])
    assert_equal(PPX::NOT_LT, errors[:field_lt])
  end
end
