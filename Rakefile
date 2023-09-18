# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :examples do
  desc 'Runs all examples'
  task :run do
    FileList['test/examples/*_example.rb'].each do |file|
      puts "#{file}:"
      puts `bundle exec ruby #{file}`
      puts ''
    end
  end
end

task default: :test
