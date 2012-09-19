module ElabsMatchers
  module Matchers
    module HaveAttribute
      rspec :type => :request

      class HaveAttributeMatcher < Struct.new(:label, :value)
        attr_reader :page

        def matches?(page)
          @page = page
          page.has_selector?(selector_type, selector)
        end

        def does_not_match?(page)
          @page = page
          page.has_no_selector?(selector_type, selector)
        end

        def failure_message_for_should
          attributes = page.all(:css, "li.wrapper").map(&:text).to_sentence
          "expected there to be an attribute #{label}: #{value}, but the only attributes were: #{attributes}."
        end

        def failure_message_for_should_not
          "expected there to be no attribute #{label}: #{value}, but there was."
        end

        private

        def selector_type
          ElabsMatchers.attribute_selector_type
        end

        def selector
          if ElabsMatchers.attribute_selector
            ElabsMatchers.attribute_selector[label, value]
          else
            XPath.generate do |x|
              x.descendant(:p)[x.attr(:class).contains("wrapper")][x.child(:strong).contains(label)][x.contains(value)]
            end
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
