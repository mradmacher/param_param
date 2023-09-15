# param_param
Params parser built on lambdas.

Inspired by Martin Chabot's [Simple Functional Strong Parameters In Ruby](https://blog.martinosis.com/blog/simple-functional-strong-params-in-ruby) article.

# Examples
An example usage is to process form data in a web application, converting
user provided data to values understood by the application and validating
if the data fulfills constraints required by the application.

## With a dedicated class:
```
class UserParams
  include ParamParam
  include ParamParam::Std

  RULES = define.(
    name: required.(
      string.(all_of.([not_nil, stripped, max_size.(50)]))
    ),
    admin: required.(bool.(any)),
    age: optional.(integer.(gt.(0))),
  )

  def verify(params)
    RULES.(params)
  end
end

class UserOperation
  def create(raw_params)
    params, errors = UserParams.new.verify(raw_params)
    throw errors unless errors.empty?

    # do something with params
  end
end
```

## A standalone example:
```
module PP
  include ParamParam
  include ParamParam::Std
end

class UserOperation
  RULES = PP.define.(
    name: PP.required.(
      PP.string.(
        PP.all_of.([
          PP.not_nil,
          PP.stripped,
          PP.max_size.(50)
        ])
      )
    ),
    admin: PP.required.(PP.bool.(PP.any)),
    age: PP.optional.(PP.integer.(PP.gt.(0))),
  )

  def create(raw_params)
    params, errors = RULES.(raw_params)
    throw errors unless errors.empty?

    # do something with params
  end
end
```
