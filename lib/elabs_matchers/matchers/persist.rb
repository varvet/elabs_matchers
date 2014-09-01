module ElabsMatchers
  module Matchers
    module Persist
      rspec :type => :model

      class PersistMatcher < Struct.new(:attribute, :value)
        attr_reader :record

        def matches?(record)
          record.send(:"#{attribute}=", value)
          record.save!
          record = record.class.find(record.id)
          @final_value = record.send(attribute)

          @final_value == value
        end

        def failure_message
          "Expected #{attribute} to be persisted and retain its value of #{value.inspect} but the value was #{@final_value.inspect}."
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "Expected #{attribute} not to be persisted and retain its value of #{value.inspect} but it did."
        end
        alias_method :failure_message_for_should_not, :failure_message_when_negated
      end

      ##
      #
      # Asserts if an assigned value persistes in the database.
      #
      # @param [Symbol] attribute       The name of the attibute to check if it persisted or not
      # @param [Object] value           The value to persist to the attribute
      #
      # Example:
      # post.should persist(:title, "Blog post")

      def persist(attribute, value)
        PersistMatcher.new(attribute, value)
      end
    end
  end
end
