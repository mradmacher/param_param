# frozen_string_literal: true

require 'test_helper'

describe ParamParam::BlankToNilOr do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::BlankToNilOr.call(ParamParam::Any),
    )
  end

  it 'convert empty string to nil' do
    params, errors = rules.call(field: '')

    assert_predicate(errors, :empty?)
    assert(params.key?(:field))
    assert_nil(params[:field])
  end

  it 'convert string with blanks to nil' do
    params, errors = rules.call(field: '   ')

    assert_predicate(errors, :empty?)
    assert(params.key?(:field))
    assert_nil(params[:field])
  end

  it 'convert nil to nil' do
    params, errors = rules.call(field: nil)

    assert_predicate(errors, :empty?)
    assert(params.key?(:field))
    assert_nil(params[:field])
  end

  it 'passes to next conversion for not blank values' do
    params, errors = rules.call(field: 666)

    assert_predicate(errors, :empty?)
    assert_equal(666, params[:field])
  end
end
