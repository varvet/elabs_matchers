module ElabsMatchers
  module Matchers
    module HaveAttribute
      rspec :type => :request

      class HaveAttributeMatcher
        attr_reader :label, :value

        def initialize(label, value)
          @label = label
          @value = value
        end

        def matches?(page)
          @page = page
          page.has_xpath?(xpath)
        end

        def does_not_match?(page)
          @page = page
          page.has_no_xpath?(xpath)
        end

        def failure_message_for_should
          attributes = @page.all(:css, "li.wrapper").map(&:text).to_sentence
          "expected there to be an attribute #{label}: #{value}, but the only attributes were: #{attributes}."
        end

        def failure_message_for_should_not
          "expected there to be no attribute #{label}: #{value}, but there was."
        end

        private

        def xpath
          XPath.generate do |x|
            x.descendant(:p)[x.attr(:class).contains("wrapper")][x.child(:strong).contains(label)][x.contains(value)]
          end
        end
      end

      ##
      #
      # Asserts if the supplied show_for* attribute exists or not
      #
      # @param [String] label            The name of the attribute.
      # @param [String] value            The value of the attribute.
      #
      # Example:
      # page.should have_attribute("Status", "Pending")
      #
      # * https://github.com/plataformatec/show_for

      def have_attribute(label, value)
        HaveAttributeMatcher.new(label, value)
      end
    end
  end
end
