# frozen_string_literal: true

require 'test_helper'

describe ParamParam::AllOf do
  let(:rules) do
    ParamParam::Rules.call(
      field: ParamParam::AllOf.call([ParamParam::Gt.call(0), ParamParam::Lt.call(10)])
    )
  end

  it 'returns value if all steps pass' do
    result = rules.call(field: 5)

    assert_predicate(result, :success?)
    assert_equal(5, result.value[:field])
  end

  it 'breaks on first not passed step' do
    result = rules.call(field: -1)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NOT_GT, result.error[:field])

    result = rules.call(field: 11)

    assert_predicate(result, :failure?)
    assert_equal(ParamParam::NOT_LT, result.error[:field])
  end
end
