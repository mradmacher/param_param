# frozen_string_literal: true

require 'test_helper'

describe ParamParam::Std.max_size do
  let(:rules) do
    ParamParam.define.call(
      field: ParamParam::Std.max_size.call(10),
    )
  end

  it 'accepts strings not longer than required size' do
    params, errors = rules.call(field: '0123456789')

    assert_predicate(errors, :empty?)
    assert_equal('0123456789', params[:field])
  end

  it 'rejects strings longer than required size' do
    _, errors = rules.call(field: '12345678910')

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::TOO_LONG, errors[:field])
  end

  it 'accepts arrays not longer than required size' do
    params, errors = rules.call(field: %w[0 1 2 3 4 5 6 7 8 9])

    assert_predicate(errors, :empty?)
    assert_equal(%w[0 1 2 3 4 5 6 7 8 9], params[:field])
  end

  it 'rejects arrays longer than required size' do
    _, errors = rules.call(field: %w[0 1 2 3 4 5 6 7 8 9 10])

    refute_predicate(errors, :empty?)
    assert_equal(ParamParam::Std::TOO_LONG, errors[:field])
  end
end
