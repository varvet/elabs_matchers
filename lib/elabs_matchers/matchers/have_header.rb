module ElabsMatchers
  module Matchers
    module HaveHeader
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the supplied header exists or not
      #
      # @param [String] text              The content of the header
      #
      # Example:
      # page.should have_header("Elabs")

      matcher :have_header do |text|
        match { |page| page.has_css?('h1,h2', :text => text) }
        match_for_should_not { |page| page.has_no_css?('h1,h2', :text => text) }

        failure_message_for_should do |page|
          headers = page.all('h1,h2').map { |h| "'#{h.text}'" }.join(", ")
          "expected header to be '#{text}' but it had the headers #{headers}"
        end
        failure_message_for_should_not { |page| "expected header not to be '#{text}' but it was" }
      end
    end
  end
end
