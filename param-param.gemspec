# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'param-param'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = 'Params parser built on lambdas'
  s.authors     = ['Michał Radmacher']
  s.email       = 'michal@radmacher.pl'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/mradmacher/param-param'
  s.license = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.metadata['rubygems_mfa_required'] = 'true'
end
