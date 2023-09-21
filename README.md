# param_param
Lambda powered pipelines.
Define pipelines transforming hash values.

Inspired by Martin Chabot's [Simple Functional Strong Parameters In Ruby](https://blog.martinosis.com/blog/simple-functional-strong-params-in-ruby) article.

# Examples
## Validate and transform a user provided data in a web application.

```
require 'param_param'
require 'param_param/std'

class UserParams
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  capitalized = ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }

  RULES = define.(
    name: required.(string.(all_of.([not_blank, max_size.(50), capitalized]))),
    admin: required.(bool.(any)),
    age: optional.(integer.(gt.(0))),
  )

  def process(params)
    RULES.(params)
  end
end

params, errors = UserParams.new.process(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)
params # {:name=>"John", :admin=>false, :age=>30}
errors # {}

params, errors = UserParams.new.process(admin: 'no', age: 'very old')
params # {:admin=>false}
errors # {:name=>:missing, :age=>:non_integer}
```

## Perform some chain of operations on provided data.
```
require 'param_param'

module Mather
  include ParamParam

  def self.add
    ->(value, option) { Success.new(Optiomist.some(option.value + value)) }.curry
  end

  def self.mul
    ->(value, option) { Success.new(Optiomist.some(option.value * value)) }.curry
  end

  def self.sub
    ->(value, option) { Success.new(Optiomist.some(option.value - value)) }.curry
  end
end

rules = Mather.define.(
  a: Mather.add.(5),
  b: Mather.mul.(3),
  c: Mather.sub.(1),
  d: Mather.all_of.([Mather.add.(2), Mather.mul.(2), Mather.sub.(2)]),
)

params, _ = rules.(
  a: 0,
  b: 1,
  c: 2,
  d: 3,
)

params # {:a=>5, :b=>3, :c=>1, :d=>8}

```
