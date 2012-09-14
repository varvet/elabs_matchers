module ElabsMatchers
  module Matchers
    module OnlyInclude
      rspec :type => :request

      class OnlyIncludeMatcher
        attr_reader :elements, :actual

        def initialize(elements)
          @elements = elements
        end

        def matches?(actual)
          @actual = actual
          elements.uniq.length == elements.length and
          actual.length == elements.length and
          elements.all? { |element| actual.include?(element) }
        end

        def failure_message_for_should
          "Expected #{actual.inspect} to only include #{elements.inspect}."
        end

        def failure_message_for_should_not
          "Expected #{actual.inspect} to not only include #{elements.inspect}, but it did."
        end
      end

      ##
      #
      # Asserts if the array contains exactly the supplied elements.
      # The order of the element do not have to match.
      #
      # @param [*Array] elements      Comma seperated list of arguments
      #
      # Example:
      # ["foo", "bar"].should only_include("bar", "foo")
      # ["foo", "bar"].should_not only_include("foo")

      def only_include(*elements)
        OnlyIncludeMatcher.new(elements)
      end
    end
  end
end
