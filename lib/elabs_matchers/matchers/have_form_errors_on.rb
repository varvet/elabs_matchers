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
            page.find_field(field).has_xpath?(xpath, :text => message)
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
          outside_input_container_xpath = %Q{ancestor::*[contains(@class, 'field_with_errors') and contains(@class, 'error')]}
          error_as_sibling_xpath = %Q{..//span[contains(@class,'error')]}
          input_nested_in_label_xpath = %Q{..//..//label/following-sibling::*[1]/self::span[@class='error']}
          twitter_bootstrap_xpath = %Q{ancestor::*[contains(concat(' ', @class, ' '), ' control-group ') and contains(concat(' ', @class, ' '), ' error ')]}

          [
            outside_input_container_xpath,
            error_as_sibling_xpath,
            input_nested_in_label_xpath,
            twitter_bootstrap_xpath
          ].join(" | ")
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
