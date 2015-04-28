module ElabsMatchers
  module Matchers
    module HaveTableRow
      rspec :type => :request
      rspec :type => :feature

      class HaveTableRowMatcher
        attr_reader :page, :table_name, :row, :options

        def initialize(table_name, row, options = {})
          @table_name = table_name
          @row = row
          @options = options
        end

        def matches?(page)
          @page = page

          if has_selector? and options[:strict]
            matches_exactly?
          else
            has_selector?
          end
        end

        def does_not_match?(page)
          @page = page
          row_not_found = (!table or table.has_no_selector?(selector_type, selector))

          if not row_not_found and options[:strict]
            !matches_exactly?
          else
            row_not_found
          end
        end

        def failure_message
          "Expected #{row.inspect} to be included in the table #{table_name}, but it wasn't:\n\n#{ascii_table}#{strict_match_row_message}"
        end
        alias_method :failure_message_for_should, :failure_message

        def failure_message_when_negated
          "Expected there to be no table #{table_name} with row #{row.inspect}, but there was.\n\n#{ascii_table}#{strict_match_row_message}"
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
              col_index = table.all("th").to_a.index { |th| th.text.include?(header.to_s) }
              col_index = if col_index then col_index + 1 else 0 end

              XPath.generate do |x|
                cell = x.child(:td, :th)[col_index.to_s.to_sym]

                if value.blank?
                  cell["not(node())".to_sym].or(cell.descendant(:input)["string-length(normalize-space(@value))=0".to_sym])
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

        def table_headers
          table.all("th").map(&:text)
        end

        def row_values
          table.find(selector_type, selector).all("td").map do |td|
            td_content(td)
          end
        end

        def to_hash
          if table and table.has_selector?(selector_type, selector)
            table_headers.zip(row_values).to_h
          end
        end

        def matches_exactly?
          to_hash == row
        end

        def has_selector?
          table and table.has_selector?(selector_type, selector)
        end

        def strict_match_row_message
          if options[:strict]
            "\n\nStrict match was made against row: #{to_hash.inspect}"
          end
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
      # @param [Hash]   row                   A hash representing the column name and value in key-value form.
      # @param [Hash]   options               strict: true, require row to match all columns in matching row. Does not work if the table contains duplicate rows.
      #
      # Example:
      # table.should have_table_row("Posts", "Title" => "First", :year => "2012")
      # table.should have_table_row("Posts", { "Title" => "First", :year => "2012" }, strict: true)

      def have_table_row(table_name, row, options = {})
        HaveTableRowMatcher.new(table_name, row, options)
      end
    end
  end
end
