module ElabsMatchers
  module Matchers
    module HaveImage
      rspec :type => :request

      class HaveImageMatcher < Struct.new(:value)
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
          images = page.all("img").map do |image|
            hash = {}
            hash[:alt]   = image[:alt]   if image[:alt].present?
            hash[:src]   = image[:src]   if image[:src].present?
            hash[:id]    = image[:id]    if image[:id].present?
            hash[:class] = image[:class] if image[:class].present?
            hash
          end.to_sentence

          if ElabsMatchers.image_selector.nil?
            "expected image alt to be '#{value}' but only had the images: #{images}."
          else
            "expected to find image '#{value}' but only had the images: #{images}."
          end
        end

        def failure_message_for_should_not
          "expected image not to be '#{value}' but it was."
        end

        private

        def selector_type
          ElabsMatchers.image_selector_type
        end

        def selector
          if ElabsMatchers.image_selector
            ElabsMatchers.image_selector[value]
          else
            "img[alt=\"#{value}\"]"
          end
        end
      end

      ##
      #
      # Asserts if the supplied image exists or not
      #
      # @param [String] value              The alt attribute content of the image
      #
      # Example:
      # page.should have_image("Logo")

      def have_image(value)
        HaveImageMatcher.new(value)
      end
    end
  end
end
