# frozen_string_literal: true

require 'test_helper'

describe ParamParam::Std::IsBool do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::Std::IsBool.call(ParamParam::Std::Any),
    )
  end

  it 'complains when field missing' do
    _, errors = rules.call({})

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::NON_BOOL, errors[:field])
  end

  it 'complains for nil' do
    _, errors = rules.call(field: nil)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::NON_BOOL, errors[:field])
  end

  it 'complains for None' do
    _, errors = rules.call(field: ParamParam::Option.None)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::NON_BOOL, errors[:field])
  end

  it 'is true for true' do
    params, errors = rules.call(field: true)

    assert_predicate(errors, :empty?)
    assert(params[:field])
  end

  it 'is false for false' do
    params, errors = rules.call(field: false)

    assert_predicate(errors, :empty?)
    refute(params[:field])
  end

  it 'is true for values that are expected to be true' do
    %w[1 on On ON t true True TRUE T y yes Yes YES Y].each do |value|
      params, errors = rules.call(field: value)

      assert_predicate(errors, :empty?, "expected #{value} to be converted to bool")
      assert(params[:field], "expected #{value} to be true")
    end
  end

  it 'is false for values that are expected to be false' do
    %w[0 off Off OFF f false False FALSE F n no No NO N].each do |value|
      params, errors = rules.call(field: value)

      assert_predicate(errors, :empty?, "expected #{value} to be converted to bool")
      refute(params[:field], "expected #{value} to be false")
    end
  end
end
