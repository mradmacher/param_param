# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::OPTIONAL' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::OPTIONAL.(p::ANY),
      }
    end
  end

  it 'succeeds when value is None' do
    params, errors = actions.call(field: Optiomist.none)

    assert_predicate errors, :empty?
    refute params.key?(:field)
  end

  it 'succeeds when field is missing' do
    params, errors = actions.call(other_field: 'some value')

    assert_predicate errors, :empty?
    refute params.key?(:field)
  end

  it 'succeeds when value is nil' do
    params, errors = actions.call(field: nil)

    assert_predicate errors, :empty?
    assert params.key?(:field)
    assert_nil params[:field]
  end

  it 'succeeds when value is present' do
    params, errors = actions.call(field: 'some value')

    assert_predicate errors, :empty?
    assert_equal 'some value', params[:field]
  end
end
