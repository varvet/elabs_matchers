module ElabsMatchers
  module Matchers
    module HaveFields
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the supplied fields exists or not
      #
      # @param [Hash] field name, value         A hash containing pairs of field name => value
      #
      # Example:
      # page.should have_fields("Author" => "Adam", "Year" => "2011")

      matcher :have_fields do |fields|
        match do |page|
          exps = fields.map { |label, value| XPath::HTML.field(label, :with => value) }
          page.has_xpath?("(./html | ./self::*)[#{exps.join(' and ')}]")
        end
        match_for_should_not do |page|
          exps = fields.map { |label, value| XPath::HTML.field(label, :with => value) }
          page.has_no_xpath?("(./html | ./self::*)[#{exps.join(' and ')}]")
        end
        failure_message_for_should { |page| "expected page to have the fields #{fields.inspect}, but it didn't." }
        failure_message_for_should_not { |page| "expected page not to have the fields #{fields.inspect}, but it did." }
      end
    end
  end
end
