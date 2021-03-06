module ElabsMatchers
  module Matchers
    module HaveHeader
      rspec :type => :request
      rspec :type => :feature
      rspec :type => :system

      class HaveHeaderMatcher < Struct.new(:text)
        attr_reader :page

        def matches?(page)
          @page = page
          page.has_selector?(selector_type, selector, :text => text)
        end

        def does_not_match?(page)
          @page = page
          page.has_no_selector?(selector_type, selector, :text => text)
        end

        def failure_message
          headers = page.all(selector_type, selector).map { |h| "'#{h.text}'" }.to_sentence
          "Expected header to be '#{text}' but it had the headers #{headers}."
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "Expected header not to be '#{text}' but it was."
        end
        alias_method :failure_message_for_should_not, :failure_message_when_negated

        private

        def selector
          ElabsMatchers.header_selector
        end

        def selector_type
          ElabsMatchers.header_selector_type
        end
      end

      ##
      #
      # Asserts if the supplied header exists or not
      #
      # @param [String] text              The content of the header
      #
      # Example:
      # page.should have_header("Elabs")

      def have_header(text)
        HaveHeaderMatcher.new(text)
      end
    end
  end
end
