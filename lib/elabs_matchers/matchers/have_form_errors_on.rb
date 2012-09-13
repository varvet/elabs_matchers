module ElabsMatchers
  module Matchers
    module HaveFormErrorsOn
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the supplied flash alert exists or not
      #
      # @param [String] label              The label content associated with the field.
      # @param [String] message             The error message expected.
      #
      # Example:
      # page.should have_form_errors_on("Name", "Can't be blank")

      matcher :have_form_errors_on do |field, message|
        xpath = %Q{..//span[contains(@class,'error')] | ..//..//label/following-sibling::*[1]/self::span[@class='error']}
        match do |page|
          if page.has_field?(field)
            field_element = page.find_field(field)
            field_element.has_xpath?(xpath, :text => message)
          end
        end
        match_for_should_not { |page| page.has_no_field?(field) or page.find_field(field).has_no_xpath?(xpath, :text => message) }

        failure_message_for_should do |page|
          if page.has_field?(field)
            error = page.find_field(field).all(:xpath, xpath).first
            if not error
              "expected field '#{field}' to have an error, but it didn't"
            elsif error.text != message
              "expected error message on #{field} to be '#{message}' but was '#{error.text}'"
            end
          else
            "No such field #{field}."
          end
        end
        failure_message_for_should_not { |page| "expected error message on '#{field}' not to be '#{message}' but it was" }
      end
    end
  end
end
