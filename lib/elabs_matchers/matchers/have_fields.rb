module ElabsMatchers
  module Matchers
    module HaveFields
      rspec :type => :request
      rspec :type => :feature
      rspec :type => :system

      class HaveFieldsMatcher < Struct.new(:fields)
        attr_reader :page

        def matches?(page)
          @page = page
          fields.all? { |label, value| page.has_field?(label, :with => value) }
        end

        def does_not_match?(page)
          @page = page
          fields.all? { |label, value| page.has_no_field?(label, :with => value) }
        end

        def failure_message
          field_values = page.all("input, textarea").map { |input| input[:value] }

          "expected page to have the fields #{fields.inspect}, but it didn't.
           The fields on the page had the following values: #{field_values.to_sentence}."
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "expected page not to have the fields #{fields.inspect}, but it did."
        end
        alias_method :failure_message_for_should_not, :failure_message_when_negated
      end

      ##
      #
      # Asserts if the supplied fields exists or not
      #
      # @param [Hash] fields         A hash containing pairs of field name => value
      #
      # Example:
      # page.should have_fields("Author" => "Adam", "Year" => "2011")

      def have_fields(fields)
        HaveFieldsMatcher.new(fields)
      end
    end
  end
end
