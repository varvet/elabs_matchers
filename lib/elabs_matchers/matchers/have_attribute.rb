module ElabsMatchers
  module Matchers
    module HaveAttribute
      extend RSpec::Matchers::DSL
      rspec :type => :request

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

      matcher :have_attribute do |label, value|
        xpath = XPath.generate { |x| x.descendant(:p)[x.attr(:class).contains('wrapper')][x.child(:strong).contains(label)][x.contains(value)] }

        match do |page|
          page.has_xpath?(xpath)
        end

        match_for_should_not do |page|
          page.has_no_xpath?(xpath)
        end

        failure_message_for_should do |page|
          attributes = page.all(:css, 'li.wrapper').map(&:text).to_sentence
          "expected there to be an attribute #{label}: #{value}, but the only attributes were: #{attributes}."
        end
        failure_message_for_should_not { |page| "expected there to be no attribute #{label}: #{value}, but there was." }
      end
    end
  end
end
