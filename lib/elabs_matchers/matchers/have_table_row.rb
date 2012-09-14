module ElabsMatchers
  module Matchers
    module HaveTableRow
      rspec :type => :request

      class HaveTableRowMatcher < Struct.new(:table_name, :row)
        attr_reader :page

        def matches?(page)
          @page = page
          table.has_xpath?(row_xpath(row))
        end

        def does_not_match?(page)
          @page = page
          table.has_no_xpath?(row_xpath(row))
        end

        def failure_message_for_should
          "Expected #{row.inspect} to be included in the table #{table_name}, but it wasn't:\n\n#{ascii_table}"
        end

        def failure_message_for_should_not
          "Expected there to be no table #{table_name} with row #{row.inspect}, but there was. Table looks like the following: \n\n#{ascii_table}"
        end

        private

        def row_xpath(row)
          exps = row.map do |header, value|
            col_index = table.all("th").index { |th| th.text.include?(header.to_s) }
            col_index = if col_index then col_index + 1 else 0 end

            XPath.generate do |x|
              if value.blank?
                x.child(:td, :th)[col_index.to_s.to_sym]["not(node())".to_sym]
              else
                x.child(:td, :th)[col_index.to_s.to_sym][x.contains(value).or(x.descendant(:input)[x.attr(:value).contains(value)])]
              end
            end
          end

          XPath.descendant["tr"][exps.reduce(:&)]
        end

        def table
          page.find(:xpath, XPath::HTML.table(table_name))
        end

        def ascii_table
          if table
            column_lengths = []
            table.all("tr").map do |tr|
              tr.all("td,th").each_with_index do |td, i|
                size = td.text.strip.size
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
                middle << td.text.strip.ljust(column_lengths[i], space)
              end

              [wall, space, middle.join(space + wall + space), space, wall].join
            end.join("\n")
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
