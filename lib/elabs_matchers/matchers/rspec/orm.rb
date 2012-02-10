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
        # @param [*Array] sample value(s)     Sample value(s) to check the validation against
        # @param [*Array] method name(s)      The method name(s) that has the validation(s) attached to it
        #
        # Example:
        # post.should allow("Elabs").as(:title)
        # post.should_not allow("").as(:title)
        #
        # post.should allow("Elabs").as(:title, :body)
        # post.should_not allow("").as(:title, :body)
        #
        # post.should allow("Elabs", "Sweden").as(:title)
        # post.should_not allow("", nil).as(:title)
        #
        # post.should allow("Elabs", "Sweden").as(:title, :body)
        # post.should_not allow("", nil).as(:title, :body)

        if defined?(ActiveModel)
          RSpec::Matchers.define :allow do |values|
            chain :as do |attributes|
              @attributes = [*attributes]
            end

            match_for_should do |actual|
              @actual, @values = actual, values
              errors.none?
            end

            match_for_should_not do |actual|
              @actual, @values = actual, values
              errors.all? and correct_number_of_errors?
            end

            def correct_number_of_errors?
              @num_errors = errors.length

              if attributes?
                if values?
                  matches_number_of_errors?(attributes, values)
                else
                  matches_number_of_errors?(attributes)
                end
              else
                if values?
                  matches_number_of_errors?(values)
                else
                  matches_number_of_errors?(1)
                end
              end
            end

            def errors
              values.map do |value|
                errors_with(value)
              end.flatten
            end

            def errors_with(value)
              attributes.each do |attribute|
                actual.send(:"#{attribute}=", value)
              end

              actual.valid?

              attributes.map do |attribute|
                actual.errors.has_key?(attribute)
              end
            end

            def matches_number_of_errors?(list1, list2 = [])
              @num_errors == ([*list1] + list2).flatten.length
            end

            def attributes?; attributes.length > 1 ; end
            def values?    ; values.length > 1     ; end
            def attributes ; @attributes           ; end
            def values     ; [*@values]            ; end
            def actual     ; @actual               ; end

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
