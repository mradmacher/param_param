# frozen_string_literal: true

require 'test_helper'

describe ParamParam do
  class PP
    include ParamParam

    I_WILL_FAIL = ->(_) { Failure.new(:some_reason) }
    I_WILL_SUCCEED = ->(option) { Success.new(option) }
  end

  it 'skips not defined fields' do
    actions = PP.define do |p|
      {
        field1: p::I_WILL_FAIL,
        field2: p::I_WILL_SUCCEED,
      }
    end
    params, errors = actions.(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_equal %i[field2], params.keys
    assert_equal %i[field1], errors.keys
    assert_equal :some_reason, errors[:field1]
    assert_equal 2, params[:field2]
  end

  it 'returns params that failed and succeeded' do
    actions = PP.define do |p|
      {
        field1: p::I_WILL_FAIL,
        field2: p::I_WILL_SUCCEED,
        field3: p::I_WILL_FAIL,
        field4: p::I_WILL_SUCCEED,
      }
    end
    params, errors = actions.(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_equal %i[field2 field4], params.keys
    assert_equal %i[field1 field3], errors.keys
    assert_equal :some_reason, errors[:field1]
    assert_equal 2, params[:field2]
    assert_equal :some_reason, errors[:field3]
    assert_equal 4, params[:field4]
  end

  it 'returns empty errors when all succeed' do
    actions = PP.define do |p|
      {
        field1: p::I_WILL_SUCCEED,
        field2: p::I_WILL_SUCCEED,
        field3: p::I_WILL_SUCCEED,
        field4: p::I_WILL_SUCCEED,
      }
    end
    params, errors = actions.(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_predicate(errors, :empty?)
    assert_equal %i[field1 field2 field3 field4], params.keys
    assert_equal 1, params[:field1]
    assert_equal 2, params[:field2]
    assert_equal 3, params[:field3]
    assert_equal 4, params[:field4]
  end

  it 'returns empty params when all fail' do
    actions = PP.define do |p|
      {
        field1: p::I_WILL_FAIL,
        field2: p::I_WILL_FAIL,
        field3: p::I_WILL_FAIL,
        field4: p::I_WILL_FAIL,
      }
    end
    params, errors = actions.(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_predicate params, :empty?
    assert_equal %i[field1 field2 field3 field4], errors.keys
    assert_equal :some_reason, errors[:field1]
    assert_equal :some_reason, errors[:field2]
    assert_equal :some_reason, errors[:field3]
    assert_equal :some_reason, errors[:field4]
  end
end
