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
          fields.all? { |label, value| page.has_field?(label, :with => value) }
        end
        match_for_should_not do |page|
          fields.all? { |label, value| page.has_no_field?(label, :with => value) }
        end
        failure_message_for_should do |page|
          "expected page to have the fields #{fields.inspect}, but it didn't."
        end
        failure_message_for_should_not do |page|
          "expected page not to have the fields #{fields.inspect}, but it did."
        end
      end
    end
  end
end
