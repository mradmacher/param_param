# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::REQUIRED' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::REQUIRED.(p::ANY),
      }
    end
  end

  it 'succeeds when there is some value' do
    params, errors = actions.call(field: "x")

    refute_predicate params, :empty?
    assert_predicate errors, :empty?
    assert_equal "x", params[:field]
  end

  it 'fails when value is None' do
    params, errors = actions.call(field: Optiomist.none)

    assert_predicate params, :empty?
    refute_predicate errors, :empty?
    assert_equal PPX::MISSING_ERR, errors[:field]
  end

  it 'fails when field is missing' do
    params, errors = actions.call(other_field: 'some value')

    assert_predicate params, :empty?
    refute_predicate errors, :empty?
    assert_equal PPX::MISSING_ERR, errors[:field]
  end

  it 'succeeds when value is nil' do
    params, errors = actions.call(field: nil)

    assert_predicate errors, :empty?
    refute_predicate params, :empty?
    assert_nil params[:field]
  end
end
