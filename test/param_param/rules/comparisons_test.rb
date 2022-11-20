# frozen_string_literal: true

require 'test_helper'

describe ParamParam::BlankToNilOr do
  let(:rules) do
    ParamParam::Rules.call(
      field_gte: ParamParam::Gte.call(0),
      field_gt: ParamParam::Gt.call(0),
      field_lte: ParamParam::Lte.call(0),
      field_lt: ParamParam::Lt.call(0)
    )
  end

  it 'returns integers when fulfill condition' do
    result = rules.call(
      field_gte: 0,
      field_gt: 1,
      field_lte: 0,
      field_lt: -1
    )

    assert_predicate result, :success?
    assert_equal(0, result.value[:field_gte])
    assert_equal(1, result.value[:field_gt])
    assert_equal(0, result.value[:field_lte])
    assert_equal(-1, result.value[:field_lt])
  end

  it 'returns decimals when fulfill condition' do
    result = rules.call(
      field_gte: 0.0,
      field_gt: 1.0,
      field_lte: 0.0,
      field_lt: -1.0
    )

    assert_predicate result, :success?
    assert_in_delta(0.0, result.value[:field_gte])
    assert_in_delta(1.0, result.value[:field_gt])
    assert_in_delta(0.0, result.value[:field_lte])
    assert_in_delta(-1.0, result.value[:field_lt])
  end

  it 'returns errors when conditions not fulfilled' do
    result = rules.call(
      field_gte: -1,
      field_gt: 0,
      field_lte: 1,
      field_lt: 0
    )

    assert_predicate result, :failure?
    assert_equal(ParamParam::NOT_GTE, result.error[:field_gte])
    assert_equal(ParamParam::NOT_GT, result.error[:field_gt])
    assert_equal(ParamParam::NOT_LTE, result.error[:field_lte])
    assert_equal(ParamParam::NOT_LT, result.error[:field_lt])
  end
end
