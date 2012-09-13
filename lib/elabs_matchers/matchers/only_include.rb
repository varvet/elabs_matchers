module ElabsMatchers
  module Matchers
    module OnlyInclude
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the array contains exactly the supplied elements.
      # The order of the element do not have to match.
      #
      # @param argument list options      comma seperated list of arguments
      #
      # Example:
      # ["foo", "bar"].should only_include("bar", "foo")
      # ["foo", "bar"].should_not only_include("foo")

      matcher :only_include do |*collection|
        match do |actual|
          collection.uniq.length == collection.length and
          actual.length == collection.length and
          collection.all? { |element| actual.include?(element) }
        end
        failure_message_for_should { |actual| "Expected #{actual.inspect} to only include #{collection.inspect}." }
        failure_message_for_should_not { |actual| "Expected #{actual.inspect} to not only include #{collection.inspect}, but it did." }
      end
    end
  end
end
