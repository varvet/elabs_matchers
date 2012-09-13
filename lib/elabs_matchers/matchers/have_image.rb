module ElabsMatchers
  module Matchers
    module HaveImage
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the supplied image exists or not
      #
      # @param [String] alt              The alt attribute content of the image
      #
      # Example:
      # page.should have_image("Logo")

      matcher :have_image do |alt|
        match { |page| page.has_css?("img[alt=\"#{alt}\"]") }
        match_for_should_not { |page| page.has_no_css?("img[alt=\"#{alt}\"]") }

        failure_message_for_should do |page|
          alts = page.all('img').map { |img| "'#{img[:alt]}'" }.to_sentence
          "expected image alt to be '#{alt}' but it had the image alts: #{alts}."
        end
        failure_message_for_should_not { |page| "expected image not to be '#{alt}' but it was" }
      end
    end
  end
end
