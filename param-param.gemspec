# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'param-param'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = 'Params parser built on lambdas'
  s.description = s.summary
  s.authors     = ['Mr Dev']
  s.email       = 'michal@radmacher.pl'
  s.files       = Dir['LICENSE', 'README.md', 'param-param.gemspec', 'lib/**/*']
  s.homepage    = 'https://github.com/mradmacher/param-param'
  s.required_ruby_version = '>= 3.0.0'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-rg'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-rake'
  s.metadata['rubygems_mfa_required'] = 'true'
end
