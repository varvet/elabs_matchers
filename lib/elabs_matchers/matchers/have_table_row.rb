module ElabsMatchers
  module Matchers
    module HaveTableRow
      rspec :type => :request
      rspec :type => :feature

      class HaveTableRowMatcher < Struct.new(:table_name, :row)
        attr_reader :page

        def matches?(page)
          @page = page
          table and table.has_selector?(selector_type, selector)
        end

        def does_not_match?(page)
          @page = page
          !table or table.has_no_selector?(selector_type, selector)
        end

        def failure_message
          "Expected #{row.inspect} to be included in the table #{table_name}, but it wasn't:\n\n#{ascii_table}"
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "Expected there to be no table #{table_name} with row #{row.inspect}, but there was.\n\n#{ascii_table}"
        end
        alias_method :failure_message_for_should_not, :failure_message_when_negated

        private

        def selector_type
          :xpath
        end

        def selector
          if ElabsMatchers.table_row_selector
            ElabsMatchers.table_row_selector[row, table]
          else
            exps = row.map do |header, value|
              XPath.generate do |x|
                header = x.axis(:ancestor, :table).descendant(:th)[x.string.n.is(header.to_s)]

                cell = x.child(:td, :th)[header][:"position() = (count(#{header.axis(:"preceding-sibling")}) + 1)"]

                if value.blank?
                  cell["not(node())".to_sym].or(cell.descendant(:input)[:"string-length(normalize-space(@value))=0"])
                else
                  cell[x.contains(value).or(x.descendant(:input)[x.attr(:value).contains(value)])]
                end
              end
            end

            XPath.descendant(:tr)[exps.reduce(:&)]
          end
        end

        def table
          if table_name.respond_to?(:tag_name) and table_name.tag_name == "table"
            table_name
          else
            table_xpath = XPath::HTML.table(table_name)

            if page.has_xpath?(table_xpath)
              page.find(:xpath, table_xpath)
            end
          end
        end

        def ascii_table
          synchronize do
            if table
              column_lengths = []
              table.all("tr").map do |tr|
                tr.all("td,th").each_with_index do |td, i|
                  size = td_content(td).strip.size
                  if (column_lengths[i] || 0) < size
                    column_lengths[i] = size
                  end
                end
              end

              table.all("tr").map do |tr|
                middle = []
                space = if tr.all("td,th").first.tag_name == "th" then "_" else " " end
                wall = "|"

                tr.all("td,th").each_with_index do |td, i|
                  middle << td_content(td).strip.ljust(column_lengths[i], space)
                end

                [wall, space, middle.join(space + wall + space), space, wall].join
              end.join("\n")
            end
          end
        end

        def td_content(td)
          text = td.text.presence
          text ||= td.find("input, textarea")[:value] if td.has_css?("input")
          text || ""
        end

        def synchronize
          if page.respond_to?(:document)
            page.document.synchronize { yield }
          else
            yield
          end
        end
      end


      ##
      #
      # Asserts if the supplied table row exists in the table
      #
      # @param [String] table_name            The tables's caption text.
      # @param [Hash] row                     A hash representing the column name and value in key-value form.
      #
      # Example:
      # table.should have_table_row("Posts", "Title" => "First", :year => "2012")

      def have_table_row(table_name, row)
        HaveTableRowMatcher.new(table_name, row)
      end
    end
  end
end
