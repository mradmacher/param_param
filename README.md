# param_param
Lambda powered pipelines.
Define pipelines transforming hash values.

Inspired by Martin Chabot's [Simple Functional Strong Parameters In Ruby](https://blog.martinosis.com/blog/simple-functional-strong-params-in-ruby) article.

# Examples
## Validate and transform a user provided data in a web application.

```
require 'param_param'
require 'param_param/std'

class MyParams
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  CAPITALIZED = ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }
end

user_params = MyParams.define do |p|
  {
    name: p::REQUIRED.(p::ALL_OF.([p::STRING, p::MIN_SIZE.(1), p::MAX_SIZE.(50), p::CAPITALIZED])),
    admin: p::REQUIRED.(p::BOOL),
    age: p::OPTIONAL.(p::ALL_OF.([p::INTEGER, p::GT.(0)])),
  }
end

params, errors = user_params.(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)

params # {:name=>"John", :admin=>false, :age=>30}
errors # {}

params, errors = UserParams.new.process(admin: 'no', age: 'very old')
params # {:admin=>false}
errors # {:name=>:missing, :age=>:not_integer}
```

## Perform some chain of operations on provided data.
```
require 'param_param'

require 'param_param'

module Mather
  include ParamParam

  ADD = ->(value, option) { Success.new(Optiomist.some(option.value + value)) }.curry
  MUL = ->(value, option) { Success.new(Optiomist.some(option.value * value)) }.curry
  SUB = ->(value, option) { Success.new(Optiomist.some(option.value - value)) }.curry
end

rules = Mather.define do |m|
  {
    a: m::ADD.(2),
    b: m::MUL.(2),
    c: m::SUB.(2),
    d: m::ALL_OF.([m::ADD.(2), m::MUL.(2), m::SUB.(2)]),
  }
end

params, errors = rules.(
  a: 10,
  b: 10,
  c: 10,
  d: 10,
)

params # {:a=>12, :b=>20, :c=>8, :d=>22}
errors # {}
```
