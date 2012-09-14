module ElabsMatchers
  module Matchers
    module HaveFormErrorsOn
      rspec :type => :request

      class HaveFormErrorsOnMatcher
        attr_reader :field, :message, :page

        def initialize(field, message)
          @field = field
          @message = message
        end

        def matches?(page)
          @page = page

          if page.has_field?(field)
            field_element = page.find_field(field)
            field_element.has_xpath?(xpath, :text => message)
          end
        end

        def does_not_match?(page)
          @page = page
          page.has_no_field?(field) || page.find_field(field).has_no_xpath?(xpath, :text => message)
        end

        def failure_message_for_should
          if page.has_field?(field)
            error = page.find_field(field).all(:xpath, xpath).first
            if not error
              "Expected field '#{field}' to have an error, but it didn't."
            elsif error.text != message
              "Expected error message on #{field} to be '#{message}' but was '#{error.text}'."
            end
          else
            "No such field #{field}."
          end
        end

        def failure_message_for_should_not
          "Expected error message on '#{field}' not to be '#{message}' but it was."
        end

        private

        def xpath
          %Q{..//span[contains(@class,'error')] | ..//..//label/following-sibling::*[1]/self::span[@class='error']}
        end
      end

      ##
      #
      # Asserts if the supplied flash alert exists or not
      #
      # @param [String] field               The label content associated with the field. Any selector which works with has_field? works here too.
      # @param [String] message             The error message expected.
      #
      # Example:
      # page.should have_form_errors_on("Name", "Can't be blank")

      def have_form_errors_on(field, message)
        HaveFormErrorsOnMatcher.new(field, message)
      end
    end
  end
end
