module ElabsMatchers
  module Matchers
    module HaveFlash
      rspec :type => :request

      class HaveFlashMatcher < Struct.new(:type, :message)
        attr_reader :page

        def matches?(page)
          @page = page
          page.has_selector?(selector_type, selector, :text => message)
        end

        def does_not_match?(page)
          @page = page
          page.has_no_selector?(selector_type, selector, :text => message)
        end

        def failure_message_for_should
          "Expected flash #{type} to be '#{message}' but was '#{page.find(selector_type, selector).text}'."
        end

        def failure_message_for_should_not
          "Expected flash #{type} to not be '#{message}' but it was."
        end

        private

        def selector_type
          ElabsMatchers.send(:"flash_#{type}_selector_type")
        end

        def selector
          ElabsMatchers.send(:"flash_#{type}_selector")
        end
      end

      ##
      #
      # Asserts if the supplied flash notice exists or not
      #
      # @param [String] message              The content of the flash notice
      #
      # Example:
      # page.should have_flash_notice("Success")

      def have_flash_notice(message)
        HaveFlashMatcher.new(:notice, message)
      end

      ##
      #
      # Asserts if the supplied flash alert exists or not
      #
      # @param [String] message              The content of the flash alert
      #
      # Example:
      # page.should have_flash_alert("Error")

      def have_flash_alert(message)
        HaveFlashMatcher.new(:alert, message)
      end
    end
  end
end
