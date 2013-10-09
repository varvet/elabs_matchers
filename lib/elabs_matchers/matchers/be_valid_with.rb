module ElabsMatchers
  module Matchers
    module BeValidWith
      if defined?(ActiveModel)
        rspec :type => :model

        class BeValidWithMatcher
          attr_reader :record, :attributes

          def initialize(values)
            @values = values
          end

          def matches?(record)
            @record = record
            errors.none?
          end

          def does_not_match?(record)
            @record = record
            errors.all? and correct_number_of_errors?
          end

          ##
          #
          # Tell the matcher which attributes to check
          #
          # @param [*Array] attributes     The method name(s) that has the validation(s) attached to it
          #
          # Example:
          # post.should be_valid_with("Elabs").as(:title)

          def as(*attributes)
            @attributes = [*attributes]
            self
          end

          def failure_message_for_should
            common_failure_message(:valid)
          end

          def failure_message_for_should_not
            common_failure_message(:invalid)
          end

          def description
            "be valid with #{@values.inspect} as #{@attributes.inspect}"
          end

          private

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
              record.send(:"#{attribute}=", value)
            end

            record.valid?

            attributes.map do |attribute|
              record.errors.keys.include?(attribute)
            end
          end

          def matches_number_of_errors?(list1, list2 = [])
            @num_errors == [*list1].concat(list2).length
          end

          def attributes?; attributes.length > 1 ; end
          def values?    ; values.length > 1     ; end
          def values     ; [*@values]            ; end

          def common_failure_message(match_type)
            "Expected #{expected_values_explain} to be #{match_type} on #{record.class.model_name}'s #{attributes_values_explain} attributes but it wasn't."
          end

          def expected_values_explain
            values.map(&:inspect).to_sentence
          end

          def attributes_values_explain
            attributes.map(&:to_s).map(&:inspect).to_sentence
          end
        end

        ##
        #
        # Asserts if a sample value is valid on a given attribute
        #
        # @param [*Array] values              Sample value(s) to check the validation against
        #
        # Example:
        # post.should be_valid_with("Elabs").as(:title)
        # post.should_not be_valid_with("").as(:title)
        #
        # post.should be_valid_with("Elabs").as(:title, :body)
        # post.should_not be_valid_with("").as(:title, :body)
        #
        # post.should be_valid_with("Elabs", "Sweden").as(:title)
        # post.should_not be_valid_with("", nil).as(:title)
        #
        # post.should be_valid_with("Elabs", "Sweden").as(:title, :body)
        # post.should_not be_valid_with("", nil).as(:title, :body)

        def be_valid_with(*values)
          BeValidWithMatcher.new(values)
        end

        ##
        #
        # This is a DEPRECATED alias for `be_valid_with`. This no longer works
        # with newer versions of RSpec
        #
        alias_method :allow, :be_valid_with
      end
    end
  end
end
