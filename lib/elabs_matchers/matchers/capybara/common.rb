module ElabsMatchers
  module Matchers
    module Capybara
      ##
      #
      # Asserts if the select input tag contains the given options.
      #
      # @param [Array] options      One or serveral strings seperated by comma
      #
      # Example:
      # find(:xpath, XPath::HTML.select("My input label")).should have_options(options)

      RSpec::Matchers.define :have_options do |*options|
        match do |select|
          options.all? { |option| select.all("option").map(&:text).include?(option) }
        end

        failure_message_for_should do |select|
          actual_options = select.all("option").map(&:text).inspect
          "expected options to include '#{options.flatten.inspect}' but it had the options #{actual_options}."
        end
        failure_message_for_should_not { |select| "expected options not to include '#{options.flatten.inspect}' but it did." }
      end
    end
  end
end