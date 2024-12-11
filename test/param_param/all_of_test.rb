# frozen_string_literal: true

require 'test_helper'

describe 'ParamParam#ALL_OF' do
  class PP
    include ParamParam

    GT = ->(limit, option) { option.value > limit ? Success.new(option) : Failure.new(:not_gt) }.curry
    LT = ->(limit, option) { option.value < limit ? Success.new(option) : Failure.new(:not_lt) }.curry
  end

  let(:actions) do
    PP.define do |p|
      {
        field: p::ALL_OF.([p::GT.(0), p::LT.(10)]),
      }
    end
  end

  it 'returns value if all steps pass' do
    params, errors = actions.(field: 5)

    assert_predicate(errors, :empty?)
    assert_equal(5, params[:field])
  end

  it 'breaks on first not passed step' do
    _, errors = actions.call(field: -1)

    refute_predicate(errors, :empty?)
    assert_equal(:not_gt, errors[:field])

    _, errors = actions.call(field: 11)

    refute_predicate(errors, :empty?)
    assert_equal(:not_lt, errors[:field])
  end
end
