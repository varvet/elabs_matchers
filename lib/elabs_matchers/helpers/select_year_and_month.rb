module ElabsMatchers
  module Helpers
    module SelectYearAndMonth
      rspec :type => :request

      ##
      #
      # Selects a year and a month on a rails date select input field.
      #
      # @param [String] year      The name of the year used in the select input field
      # @param [String] month     The name of the month used in the select input field
      # @param [Hash] options     The label of the select field
      #
      # Example:
      # select_year_and_month("2010", "March", :from => "Birth date")

      def select_year_and_month(year, month, options={})
        year_field = find_field(options[:from])
        month_field = find(:id, year_field[:id].sub(/_1i$/, "_2i"))

        year_field.select(year)
        month_field.select(month)
      end
    end
  end
end
