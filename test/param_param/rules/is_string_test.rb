# frozen_string_literal: true

require 'test_helper'

describe ParamParam::IsString do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::IsString.call(ParamParam::Any)
    )
  end

  it 'complains when field missing' do
    result = rules.call({})

    assert_predicate result, :failure?
    assert_equal ParamParam::NON_STRING, result.error[:field]
  end

  it 'converts nil to empty string' do
    result = rules.call(field: nil)

    assert_predicate result, :success?
    assert_equal '', result.value[:field]
  end

  it 'complains for None' do
    result = rules.call(field: ParamParam::Option.None)

    assert_predicate result, :failure?
    assert_equal ParamParam::NON_STRING, result.error[:field]
  end

  it 'converts numbers to strings' do
    result = rules.call(field: 1.2)

    assert_predicate result, :success?
    assert_equal '1.2', result.value[:field]
  end

  it 'converts booleans to strings' do
    result = rules.call(field: true)

    assert_predicate result, :success?
    assert_equal 'true', result.value[:field]
  end

  it 'leaves strings untouched' do
    result = rules.call(field: ' do not touch me ')

    assert_predicate result, :success?
    assert_equal ' do not touch me ', result.value[:field]
  end
end
