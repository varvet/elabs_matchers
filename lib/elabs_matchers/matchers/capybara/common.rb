module ElabsMatchers
  module Matchers
    module Capybara
      module Common
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

            exps = row.map do |header, value|
              col_index = table.all("thead th").index { |th| th.text.include?(header) }
              col_index = if col_index then col_index + 1 else 0 end
              XPath.child(:td, :th)[col_index.to_s.to_sym][XPath.contains(value)]
            end
            exps = exps.inject { |agg, exp| agg & exp }
            table.has_xpath?(XPath.descendant['tr'][exps])
          end

          match_for_should_not do |page|
            if page.has_no_table?(table_name)
              true
            else
              table = page.find(:xpath, XPath::HTML.table(table_name))

              exps = row.map do |header, value|
                col_index = table.all("thead th").index { |th| th.text.include?(header) }
                col_index = if col_index then col_index + 1 else 0 end
                XPath.child(:td, :th)[col_index.to_s.to_sym][XPath.contains(value)]
              end
              exps = exps.inject { |agg, exp| agg & exp }
              table.has_no_xpath?(XPath.descendant['tr'][exps])
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
          match_for_should_not { |page| page.has_no_css?("img[alt=\"#{alt}\"]") }

          failure_message_for_should do |page|
            alts = page.all('img').map { |img| "'#{img[:alt]}'" }.to_sentence
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
          match_for_should_not { |page| page.has_no_css?('h1,h2', :text => text) }

          failure_message_for_should do |page|
            headers = page.all('h1,h2').map { |h| "'#{h.text}'" }.to_sentence
            "expected header to be '#{text}' but it had the headers #{headers}"
          end
          failure_message_for_should_not { |page| "expected header not to be '#{text}' but it was" }
        end

        ##
        #
        # Asserts if the supplied flash notice exists or not
        #
        # @param [String] text              The content of the flash notice
        #
        # Example:
        # page.should have_flash_notice("Success")

        RSpec::Matchers.define :have_flash_notice do |text|
          match { |page| page.has_css?('#flash.notice, #flash .notice', :text => text) }
          match_for_should_not { |page| page.has_no_css?('#flash.notice, #flash .notice', :text => text) }
          failure_message_for_should { |page| "expected flash notice to be '#{text}' but was '#{page.find('#flash.notice').text}'" }
          failure_message_for_should_not { |page| "expected flash notice not to be '#{text}' but it was" }
        end

        ##
        #
        # Asserts if the supplied flash alert exists or not
        #
        # @param [String] text              The content of the flash alert
        #
        # Example:
        # page.should have_flash_alert("Error")

        RSpec::Matchers.define :have_flash_alert do |text|
          match { |page| page.has_css?('#flash.alert, #flash .alert', :text => text) }
          match_for_should_not { |page| page.has_no_css?('#flash.alert, #flash .alert', :text => text) }
          failure_message_for_should { |page| "expected flash alert to be '#{text}' but was '#{page.find('#flash.alert').text}'" }
          failure_message_for_should_not { |page| "expected flash alert not to be '#{text}' but it was" }
        end

        ##
        #
        # Asserts if the supplied flash alert exists or not
        #
        # @param [String] label              The label content associated with the field.
        # @param [String] message             The error message expected.
        #
        # Example:
        # page.should have_form_errors_on("Name", "Can't be blank")

        RSpec::Matchers.define :have_form_errors_on do |field, message|
          xpath = %Q{..//span[contains(@class,'error')]}
          match { |page| page.has_field?(field) and page.find_field(field).has_xpath?(xpath, :text => message) }
          match_for_should_not { |page| page.has_no_field?(field) or page.find_field(field).has_no_xpath?(xpath, :text => message) }

          failure_message_for_should do |page|
            error = page.find_field(field).all(:xpath, xpath).first
            if not error
              "expected field '#{field}' to have an error, but it didn't"
            elsif error.text != message
              "expected error message on #{field} to be '#{message}' but was '#{error.text}'"
            else
              raise "This should not happen"
            end
          end
          failure_message_for_should_not { |page| "expected error message on '#{field}' not to be '#{text}' but it was" }
        end

        ##
        #
        # Asserts if the supplied fields exists or not
        #
        # @param [Hash] field name, value         A hash containing pairs of field name => value
        #
        # Example:
        # page.should have_fields("Author" => "Adam", "Year" => "2011")

        RSpec::Matchers.define :have_fields do |fields|
          match do |page|
            exps = fields.map { |label, value| XPath::HTML.field(label, :with => value) }
            page.has_xpath?("(./html | ./self::*)[#{exps.join(' and ')}]")
          end
          match_for_should_not do |page|
            exps = fields.map { |label, value| XPath::HTML.field(label, :with => value) }
            page.has_no_xpath?("(./html | ./self::*)[#{exps.join(' and ')}]")
          end
          failure_message_for_should { |page| "expected page to have the fields #{fields.inspect}, but it didn't." }
          failure_message_for_should_not { |page| "expected page not to have the fields #{fields.inspect}, but it did." }
        end
      end
    end
  end
end
