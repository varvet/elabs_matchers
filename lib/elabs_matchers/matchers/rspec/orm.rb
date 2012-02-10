module ElabsMatchers
  module Matchers
    module Rspec
      module Orm
        ##
        #
        # Asserts if an assigned value persistes in the database.
        #
        # @param [Symbol] attribute name      The name of the attibute to check if it persisted or not
        # @param [Object] value               The value to persist to the attribute
        #
        # Example:
        # post.should persist(:title, "Blog post")

        RSpec::Matchers.define :persist do |attribute, value|
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

        ##
        #
        # Asserts if a sample value is valid on a given attribute
        #
        # @param [String] sample value        A sample value to check the validation against
        # @param [Symbol] method name         The method name that has the validation attached to it
        #
        # Example:
        # post.should allow("Elabs").as(:title)
        # post.should_not allow("").as(:title)
        #
        if defined?(ActiveModel)
          RSpec::Matchers.define :allow do |values|
            chain :as do |attributes|
              @attributes = attributes
            end

            match do |actual|
              attribute = Array(@attributes).first
              value = Array(values).first

              actual.send(:"#{attribute}=", value)
              actual.valid?

              not actual.errors.has_key?(attribute)
            end

            failure_message_for_should do |actual|
              "Expected #{values.inspect} to be valid on #{actual.class.model_name.demodulize}##{@attributes.inspect} but it wasn't."
            end

            failure_message_for_should_not do |actual|
              "Expected #{values.inspect} to be invalid on #{actual.class.model_name.demodulize}##{@attributes.inspect} but it wasn't."
            end
          end
        end
      end
    end
  end
end
