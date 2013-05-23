module ElabsMatchers
  module Matchers
    module ContainHash
      rspec

      class ContainHashMatcher < Struct.new(:expected, :actual)
        def matches?(actual)
          self.actual = actual
          contains?(expected, actual)
        end

        def failure_message_for_should
          "Expected #{expected.inspect} to exist in #{actual.inspect} but it did not."
        end

        def failure_message_for_should_not
          "Expected #{expected.inspect} to not exist in #{actual.inspect} but it did."
        end

        private

        def contains?(expected, actual)
          return false unless actual.is_a?(expected.class)

          if expected.is_a?(Array)
            expected.all? do |expected_value|
              actual.any? do |actual_value|
                contains?(expected_value, actual_value)
              end
            end
          elsif expected.is_a?(Hash)
            expected.all? do |key, value|
              contains?(value, actual[key])
            end
          else
            actual == expected
          end
        end

      end

      ##
      #
      # Asserts if the hash contains the supplied hash.
      # Works with nested hashes and array of hashes.
      #
      # @param [Hash] hash      Key => value pairs seperated by comma
      #
      # Example:
      # { "foo" => ["quox", { "bar" => "baz"}]}.should contain_hash({ "foo" => [{ "bar" => "baz" }]})
      # { "foo" => "bar", "baz" => "quox" }.should_not contain_hash({ "baz" => "bar" })

      def contain_hash(hash)
        ContainHashMatcher.new(hash)
      end
    end
  end
end
