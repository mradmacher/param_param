# frozen_string_literal: true

require 'test_helper'

describe ParamParam::Std::IsString do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::Std::IsString.call(ParamParam::Std::Any),
    )
  end

  it 'complains when field missing' do
    _, errors = rules.call({})

    refute_predicate(errors, :empty?)
    assert_equal ParamParam::Std::NON_STRING, errors[:field]
  end

  it 'converts nil to empty string' do
    params, errors = rules.call(field: nil)

    assert_predicate(errors, :empty?)
    assert_equal '', params[:field]
  end

  it 'complains for None' do
    _, errors = rules.call(field: ParamParam::Option.None)

    refute_predicate(errors, :empty?)
    assert_equal ParamParam::Std::NON_STRING, errors[:field]
  end

  it 'converts numbers to strings' do
    params, errors = rules.call(field: 1.2)

    assert_predicate(errors, :empty?)
    assert_equal '1.2', params[:field]
  end

  it 'converts booleans to strings' do
    params, errors = rules.call(field: true)

    assert_predicate(errors, :empty?)
    assert_equal 'true', params[:field]
  end

  it 'leaves strings untouched' do
    params, errors = rules.call(field: ' do not touch me ')

    assert_predicate(errors, :empty?)
    assert_equal ' do not touch me ', params[:field]
  end
end
