ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
require 'capybara'
require 'active_model'
require 'elabs_matchers'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara
end
