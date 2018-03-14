ENV["RAILS_ENV"] = "test"

require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "active_model"
require "elabs_matchers"

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara::DSL

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec

  %w[helpers matchers].each do |dir|
    Dir[File.join(File.expand_path(File.dirname(__FILE__)), "../lib/elabs_matchers/#{dir}/*.rb")].each do |file|
      file = file.split("/").last.split(".").first
      config.include("ElabsMatchers::#{dir.camelize}::#{file.camelize}".constantize)
    end
  end

  config.after do
    ElabsMatchers.use_default_configuration!
  end
end

module RSpec
  module Matchers
    def fail_assertion(message = nil)
      raise_error(RSpec::Expectations::ExpectationNotMetError, message)
    end
  end
end
