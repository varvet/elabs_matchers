module ElabsMatchers
  module Matchers
    module Rspec
      module Orm
        extend RSpec::Matchers::DSL

        ##
        #
        # Asserts if an assigned value persistes in the database.
        #
        # @param [Symbol] attribute name      The name of the attibute to check if it persisted or not
        # @param [Object] value               The value to persist to the attribute
        #
        # Example:
        # post.should persist(:title, "Blog post")

        matcher :persist do |attribute, value|
          match do |actual|
            actual.send(:"#{attribute}=", value)
            actual.save!
            actual = actual.class.find(actual.id)
            @final_value = actual.send(attribute)
            @final_value == value
          end
          failure_message_for_should { |actual| "Expected #{attribute} to be persisted and retain its value of #{value.inspect} but the value was #{@final_value.inspect}" }
          failure_message_for_should_not { |actual| "Expected #{attribute} not to be persisted and retain its value of #{value.inspect} but it did." }
        end
      end
    end
  end
end
