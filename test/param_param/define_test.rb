# frozen_string_literal: true

require 'test_helper'

class MyParamParam
  include ParamParam

  i_will_fail = ->(_option) { ParamParam::Failure.new(:some_reason) }
  i_will_succeed = ->(option) { ParamParam::Success.new(option) }

  Rules = define.(
    field1: i_will_fail,
    field2: i_will_succeed,
  )

  def execute(params)
    Rules.(params)
  end
end

describe ParamParam do
  let(:i_will_fail) { ->(_option) { ParamParam::Failure.new(:some_reason) } }
  let(:i_will_succeed) { ->(option) { ParamParam::Success.new(option) } }

  it 'can be included in a module/class' do
    my_pp = MyParamParam.new
    params, errors = my_pp.execute(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_equal(%i[field2], params.keys)
    assert_equal(%i[field1], errors.keys)
    assert_equal(:some_reason, errors[:field1])
    assert_equal(2, params[:field2])
  end

  it 'returns params that failed and succeeded' do
    rules = PP.define.(
      field1: i_will_fail,
      field2: i_will_succeed,
      field3: i_will_fail,
      field4: i_will_succeed,
    )
    params, errors = rules.call(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_equal(%i[field2 field4], params.keys)
    assert_equal(%i[field1 field3], errors.keys)
    assert_equal(:some_reason, errors[:field1])
    assert_equal(2, params[:field2])
    assert_equal(:some_reason, errors[:field3])
    assert_equal(4, params[:field4])
  end

  it 'returns empty errors when all succeed' do
    rules = PP.define.(
      field1: i_will_succeed,
      field2: i_will_succeed,
      field3: i_will_succeed,
      field4: i_will_succeed,
    )
    params, errors = rules.call(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_predicate(errors, :empty?)
    assert_equal(%i[field1 field2 field3 field4], params.keys)
    assert_equal(1, params[:field1])
    assert_equal(2, params[:field2])
    assert_equal(3, params[:field3])
    assert_equal(4, params[:field4])
  end

  it 'returns empty params when all fail' do
    rules = PP.define.(
      field1: i_will_fail,
      field2: i_will_fail,
      field3: i_will_fail,
      field4: i_will_fail,
    )
    params, errors = rules.call(
      field1: 1,
      field2: 2,
      field3: 3,
      field4: 4,
    )

    assert_predicate(params, :empty?)
    assert_equal(%i[field1 field2 field3 field4], errors.keys)
    assert_equal(:some_reason, errors[:field1])
    assert_equal(:some_reason, errors[:field2])
    assert_equal(:some_reason, errors[:field3])
    assert_equal(:some_reason, errors[:field4])
  end
end
