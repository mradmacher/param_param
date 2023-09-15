# frozen_string_literal: true

require 'test_helper'

describe 'ParamParam.all_of' do
  let(:rules) do
    PPX.define.(
      field: PPX.all_of.([PPX.gt.(0), PPX.lt.(10)]),
    )
  end

  it 'returns value if all steps pass' do
    params, errors = rules.(field: 5)

    assert_predicate(errors, :empty?)
    assert_equal(5, params[:field])
  end

  it 'breaks on first not passed step' do
    _, errors = rules.call(field: -1)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_GT, errors[:field])

    _, errors = rules.call(field: 11)

    refute_predicate(errors, :empty?)
    assert_equal(PPX::NOT_LT, errors[:field])
  end
end
