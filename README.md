# param_param
Params parser built on lambdas.
It allows to define pipelines that transform hash values.

Inspired by Martin Chabot's [Simple Functional Strong Parameters In Ruby](https://blog.martinosis.com/blog/simple-functional-strong-params-in-ruby) article.

# Examples
An example usage is to process form data in a web application,
validating and transforming user provided data.

## A class example:
```
class UserParams
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  capitalized = ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }

  RULES = define.(
    name: required.(
      string.(all_of.([not_blank, max_size.(50), capitalized]))
    ),
    admin: required.(bool.(any)),
    age: optional.(integer.(gt.(0))),
  )

  def process(params)
    RULES.(params)
  end
end

raw_params = { name: 'JOHN', admin: '0', age: '30', race: 'It is not important' }
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

## A module example:
```
module PP
  include ParamParam
  include ParamParam::Std

  # You can add your own actions
  def self.capitalized
    ->(option) { Success.new(Optiomist.some(option.value.capitalize)) }
  end
end

rules = PP.define.(
  name: PP.required.(
    PP.string.(PP.all_of.([PP.not_blank, PP.max_size.(50), PP.capitalized]))
  ),
  admin: PP.required.(PP.bool.(PP.any)),
  age: PP.optional.(PP.integer.(PP.gt.(0))),
)

params, errors = rules.(
  name: 'JOHN',
  admin: '0',
  age: '30',
  race: 'It is not important',
)
params # {:name=>"John", :admin=>false, :age=>30}
errors # {}

params, errors = rules.(admin: 'no', age: 'very old')
params # {:admin=>false}
errors # {:name=>:missing, :age=>:non_integer}
```
