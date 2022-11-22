# frozen_string_literal: true

require 'test_helper'

describe ParamParam::AllOf do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::AllOf.call([ParamParam::Gt.call(0), ParamParam::Lt.call(10)]),
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
    assert_equal(ParamParam::NOT_GT, errors[:field])

    _, errors = rules.call(field: 11)

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::NOT_LT, errors[:field])
  end
end
