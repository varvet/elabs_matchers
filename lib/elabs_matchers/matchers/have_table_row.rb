module ElabsMatchers
  module Matchers
    module HaveTableRow
      rspec :type => :request

      class HaveTableRowMatcher < Struct.new(:table_name, :row)
        attr_reader :page

        def matches?(page)
          @page = page

          if row.is_a? Hash
            exps = row.map do |header, value|
              col_index = table.all("thead th").index { |th| th.text.include?(header) }
              col_index = if col_index then col_index + 1 else 0 end

              # Test me, I'm supposed to asssert that empty cells really are empty
              # and that if there's an input with a value of value that it matches too
              XPath.generate do |x|
                if value.blank?
                  x.child(:td, :th)[col_index.to_s.to_sym]["not(node())".to_sym]
                else
                  x.child(:td, :th)[col_index.to_s.to_sym][x.contains(value).or(x.descendant(:input)[x.attr(:value).contains(value)])]
                end
              end
            end
            exps = exps.inject { |agg, exp| agg & exp }
            table.has_xpath?(XPath.descendant["tr"][exps])
          else
            exps = []
            row.each_with_index do |value, index|
              exps << XPath.child(:td)[(index + 1).to_s.to_sym][XPath.contains(value)]
            end
            exps = exps.inject { |agg, exp| agg & exp }

            table.has_xpath?(XPath.descendant["tr"][exps])
          end
        end

        def does_not_match?(page)
          @page = page

          if row.is_a? Hash
            exps = row.map do |header, value|
              col_index = table.all("thead th").index { |th| th.text.include?(header) }
              col_index = if col_index then col_index + 1 else 0 end
              XPath.child(:td, :th)[col_index.to_s.to_sym][XPath.contains(value)]
            end
            exps = exps.inject { |agg, exp| agg & exp }
            table.has_no_xpath?(XPath.descendant["tr"][exps])
          else
            exps = []
            row.each_with_index do |value, index|
              exps << XPath.child(:td)[(index + 1).to_s.to_sym][XPath.contains(value)]
            end
            exps = exps.inject { |agg, exp| agg & exp }

            table.has_no_xpath?(XPath.descendant["tr"][exps])
          end
        end

        def failure_message_for_should
          "Expected #{row.inspect} to be included in the table #{table_name}, but it wasn't:\n\n#{ascii_table}"
        end

        def failure_message_for_should_not
          "Expected there to be no table #{table_name} with row #{row.inspect}, but there was."
        end

        private

        def table
          page.find(:xpath, XPath::HTML.table(table_name))
        end

        def ascii_table
          table.all("tr").map do |tr|
            "| " + tr.all("td,th").map { |td| td.text.strip.ljust(21) }.join(" | ") + " |"
          end.join("\n")
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
