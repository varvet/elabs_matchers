module ElabsMatchers
  module Matchers
    module HaveImage
      rspec :type => :request

      class HaveImageMatcher < Struct.new(:alt)
        attr_reader :page

        def matches?(page)
          @page = page
          page.has_css?(selector)
        end

        def does_not_match?(page)
          @page = page
          page.has_no_css?(selector)
        end

        def failure_message_for_should
          alts = page.all("img").map { |img| "'#{img[:alt]}'" }.to_sentence
          "expected image alt to be '#{alt}' but it had the image alts: #{alts}."
        end

        def failure_message_for_should_not
          "expected image not to be '#{alt}' but it was"
        end

        private

        def selector
          "img[alt=\"#{alt}\"]"
        end
      end

      ##
      #
      # Asserts if the supplied image exists or not
      #
      # @param [String] alt              The alt attribute content of the image
      #
      # Example:
      # page.should have_image("Logo")

      def have_image(alt)
        HaveImageMatcher.new(alt)
      end
    end
  end
end
