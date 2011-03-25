require 'bundler'
require 'rubygems'
require 'rspec/core/rake_task'
require 'yard'

Bundler::GemHelper.install_tasks

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'README.rdoc']
end

task :default => :spec
