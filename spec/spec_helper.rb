ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
require 'capybara'

Dir[File.join(File.expand_path(File.dirname(__FILE__)), "../lib/elabs_matchers/**/*.rb")].each { |file| require file }

Rspec.configure do |config|
  config.mock_with :rspec
  config.include Capybara
end