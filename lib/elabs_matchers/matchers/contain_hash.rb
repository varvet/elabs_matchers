module ElabsMatchers
  module Matchers
    module ContainHash
      extend RSpec::Matchers::DSL
      rspec

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

      matcher :contain_hash do |expected|
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
    end
  end
end
