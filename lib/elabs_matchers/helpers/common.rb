module ElabsMatchers
  module Helpers
    module Common

      ##
      #
      # Normalizes a hash so that it can be described in a more
      # human friendly manner.
      #
      # @param [Hash] options     A hash of human-friendly key and value pairs.
      #
      # Examples:
      # normalize_keys({ "First name" => "Adam" }) => HashWithIndifferentAccess.new({ "first_name" => "adam" })
      #
      # # Or in a Cucumber table:
      # Given the following people:
      #  | First name | Last name |
      #  | Douglas    | Adams     |
      #

      def normalize_keys(hash)
        hash.inject(HashWithIndifferentAccess.new) do |new_hash, (key, value)|
          new_hash[key.parameterize("_")] = value
          new_hash
        end
      end
    end
  end
end
