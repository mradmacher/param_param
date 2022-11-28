# frozen_string_literal: true

require 'test_helper'

describe ParamParam.all_of do
  let(:rules) do
    ParamParam.define.call(
      field: ParamParam.all_of.call([ParamParam::Std.gt.call(0), ParamParam::Std.lt.call(10)]),
    )
  end

  it 'returns value if all steps pass' do
    params, errors = rules.call(field: 5)

    assert_predicate(errors, :empty?)
    assert_equal(5, params[:field])
  end

  it 'breaks on first not passed step' do
    _, errors = rules.call(field: -1)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::NOT_GT, errors[:field])

    _, errors = rules.call(field: 11)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::NOT_LT, errors[:field])
  end
end
