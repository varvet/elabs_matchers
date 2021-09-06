module ElabsMatchers
  module Matchers
    module OnlyInclude
      rspec

      class OnlyIncludeMatcher < Struct.new(:elements)
        attr_reader :actual

        def matches?(actual)
          deprecated

          @actual = actual
          elements.uniq.length == elements.length and
          actual.length == elements.length and
          elements.all? { |element| actual.include?(element) }
        end

        def failure_message
          "Expected #{actual.inspect} to only include #{elements.inspect}."
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "Expected #{actual.inspect} to not only include #{elements.inspect}, but it did."
        end
        alias_method :failure_message_for_should_not, :failure_message_when_negated

        private

        def deprecated
          warn %Q{
            [DEPRECATION] `only_include` is deprecated.  Please use rspec's `contain_exactly` instead. Called from #{Kernel.caller.first}
          }
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
