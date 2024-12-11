# frozen_string_literal: true

require 'test_std_helper'

describe 'ParamParam::Std::STRING' do
  let(:actions) do
    PPX.define do |p|
      {
        field: p::STRING,
      }
    end
  end

  it 'complains when field missing' do
    _, errors = actions.call({})

    refute_predicate(errors, :empty?)
    assert_equal PPX::NOT_STRING_ERR, errors[:field]
  end

  it 'converts nil to empty string' do
    params, errors = actions.call(field: nil)

    assert_predicate(errors, :empty?)
    assert_equal '', params[:field]
  end

  it 'complains for None' do
    _, errors = actions.call(field: Optiomist.none)

    refute_predicate(errors, :empty?)
    assert_equal PPX::NOT_STRING_ERR, errors[:field]
  end

  it 'converts numbers to strings' do
    params, errors = actions.call(field: 1.2)

    assert_predicate(errors, :empty?)
    assert_equal '1.2', params[:field]
  end

  it 'converts booleans to strings' do
    params, errors = actions.call(field: true)

    assert_predicate(errors, :empty?)
    assert_equal 'true', params[:field]
  end

  it 'leaves strings untouched' do
    params, errors = actions.call(field: ' do not touch me ')

    assert_predicate(errors, :empty?)
    assert_equal ' do not touch me ', params[:field]
  end
end
