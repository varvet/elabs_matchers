module ElabsMatchers
  module Matchers
    module Capybara
      ##
      #
      # Asserts if the select input tag contains the given options.
      #
      # @param [Array] options      One or serveral strings seperated by comma
      #
      # Example:
      # find(:xpath, XPath::HTML.select("My input label")).should have_options(options)

      RSpec::Matchers.define :have_options do |*options|
        match do |select|
          options.all? { |option| select.all("option").map(&:text).include?(option) }
        end

        failure_message_for_should do |select|
          actual_options = select.all("option").map(&:text).inspect
          "expected options to include '#{options.flatten.inspect}' but it had the options #{actual_options}."
        end
        failure_message_for_should_not { |select| "expected options not to include '#{options.flatten.inspect}' but it did." }
      end

      ##
      #
      # Asserts if the supplied table row exists in the table
      #
      # @param [String] table name            The tables's caption text.
      # @param [Hash] column value            A hash representing the column name and value in key-value form.
      #
      # Example:
      # table.should have_table_row('Posts', "Title" => "First", :year => "2012")

      RSpec::Matchers.define :have_table_row do |table_name, row|
        match do |page|
          table = page.find(:xpath, XPath::HTML.table(table_name))
          row_index = nil

          row.all? do |header, value|
            col_index = table.all("thead th").index { |th| th.text.include?(header) }
            col_index = if col_index then col_index + 1 else 0 end

            current_row_index = table.all("tbody tr").index { |tr| tr.text.include?(value) }
            correct_row = row_index.nil? || current_row_index == row_index
            row_index = current_row_index

            correct_row and table.has_xpath?(".//td[#{col_index}][contains(.,'#{value}')]")
          end
        end

        failure_message_for_should do |page|
          table = page.find(:xpath, XPath::HTML.table(table_name))
          ascii_table = table.all('tr').map do |tr|
            '| ' + tr.all('td,th').map { |td| td.text.strip.ljust(21) }.join(' | ') + ' |'
          end.join("\n")
          "expected #{row.inspect} to be included in the table #{table_name}, but it wasn't:\n\n#{ascii_table}"
        end
        failure_message_for_should_not { |page| "expected there to be no table #{table_name} with row #{row.inspect}, but there was." }
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

      RSpec::Matchers.define :have_attribute do |label, value|
        match do |page|
          xpath = XPath.generate { |x| x.descendant(:p)[x.attr(:class).contains('wrapper')][x.child(:strong).contains(label)][x.contains(value)] }
          page.has_xpath?(xpath)
        end

        failure_message_for_should do |page|
          attributes = page.all(:css, 'li.wrapper').map(&:text).join(", ")
          "expected there to be an attribute #{label}: #{value}, but the only attributes were: #{attributes}."
        end
        failure_message_for_should_not { |page| "expected there to be no attribute #{label}: #{value}, but there was." }
      end

      ##
      #
      # Asserts if the supplied image exists or not
      #
      # @param [String] alt              The alt attribute content of the image
      #
      # Example:
      # page.should have_image("Logo")

      RSpec::Matchers.define :have_image do |alt|
        match { |page| page.has_css?("img[alt=\"#{alt}\"]") }

        failure_message_for_should do |page|
          alts = page.all('img').map { |img| "'#{img[:alt]}'" }.join(", ")
          "expected image alt to be '#{alt}' but it had the image alts: #{alts}."
        end
        failure_message_for_should_not { |page| "expected image not to be '#{alt}' but it was" }
      end

      ##
      #
      # Asserts if the supplied header exists or not
      #
      # @param [String] text              The content of the header
      #
      # Example:
      # page.should have_header("Elabs")

      RSpec::Matchers.define :have_header do |text|
        match { |page| page.has_css?('h1,h2', :text => text) }

        failure_message_for_should do |page|
          headers = page.all('h1,h2').map { |h| "'#{h.text}'" }.join(", ")
          "expected header to be '#{text}' but it had the headers #{headers}"
        end
        failure_message_for_should_not { |page| "expected header not to be '#{text}' but it was" }
      end
    end
  end
end