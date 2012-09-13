module ElabsMatchers
  module Matchers
    module Allow
      extend RSpec::Matchers::DSL
      rspec :request => :model

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
        matcher :allow do |*values|
          chain :as do |*attributes|
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
            end.flatten.compact
          end

          def errors_with(value)
            attributes.each do |attribute|
              actual.send(:"#{attribute}=", value)
            end

            actual.valid?

            attributes.map do |attribute|
              actual.errors.keys.include?(attribute)
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
            common_failure_message(:valid)
          end

          failure_message_for_should_not do |actual|
            common_failure_message(:invalid)
          end

          def common_failure_message(match_type)
            "Expected #{expected_values_explain} to be #{match_type} on #{actual.class.model_name.demodulize}'s #{attributes_values_explain} attributes but it wasn't."
          end

          def expected_values_explain
            values.map(&:inspect).to_sentence
          end

          def attributes_values_explain
            attributes.map(&:to_s).map(&:inspect).to_sentence
          end
        end
      end
    end
  end
end
