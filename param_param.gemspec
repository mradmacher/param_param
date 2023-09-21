# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'param_param'
  s.version     = '0.0.2'
  s.licenses    = ['MIT']
  s.summary     = 'Lambda powered pipelines for hash values'
  s.authors     = ['Michał Radmacher']
  s.email       = 'michal@radmacher.pl'
  s.files       = Dir['lib/**/*.rb']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.homepage    = 'https://github.com/mradmacher/param_param'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7.0'
  s.metadata['rubygems_mfa_required'] = 'true'

  s.add_dependency 'optiomist', '~> 0.0.3'
end
