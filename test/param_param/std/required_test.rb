# frozen_string_literal: true

require 'test_helper'

describe ParamParam::Std::Required do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::Std::Required.call(ParamParam::Std::Any),
    )
  end

  it 'fails when value is None' do
    _, errors = rules.call(field: ParamParam::Option.None)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::MISSING, errors[:field])
  end

  it 'fails when field is missing' do
    _, errors = rules.call(other_field: 'some value')

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::MISSING, errors[:field])
  end

  it 'succeeds when value is nil' do
    params, errors = rules.call(field: nil)

    assert_predicate(errors, :empty?)
    assert_nil(params[:field])
  end
end
