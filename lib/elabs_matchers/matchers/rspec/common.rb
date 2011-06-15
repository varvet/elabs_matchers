module ElabsMatchers
  module Matchers
    module Rspec
      ##
      #
      # Asserts if the hash contains the supplied hash.
      # Works with nested hashes and array of hashes.
      #
      # @param [Hash] options      Key => value pairs seperated by comma
      #
      # Example:
      # { "foo" => ['quox', { 'bar' => 'baz'}]}.should contain_hash({ "foo" => [{ "bar" => "baz" }]})
      # { "foo" => "bar", "baz" => "quox" }.should_not contain_hash({ "baz" => "bar" })

      RSpec::Matchers.define :contain_hash do |expected|
        match do |actual|
          contains?(expected, actual)
        end

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
      # Asserts if the array contains exactly the supplied elements.
      # The order of the element do not have to match.
      #
      # @param argument list options      comma seperated list of arguments
      #
      # Example:
      # ["foo", "bar"].should only_include("bar", "foo")
      # ["foo", "bar"].should_not only_include("foo")

      RSpec::Matchers.define :only_include do |*collection|
        match { |actual| actual.length == collection.length and collection.all? { |element| actual.include?(element) }  }
        failure_message_for_should { |actual| "Expected #{actual.inspect} to only include #{collection.inspect}." }
        failure_message_for_should_not { |actual| "Expected #{actual.inspect} to not only include #{collection.inspect}, but it did." }
      end
    end
  end
end