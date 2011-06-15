module ElabsMatchers
  module Capybara
    def select_year_and_month(year, month, options={})
      year_field = find_field(options[:from])
      month_field = find(:id, year_field[:id].sub(/_1i$/, '_2i'))

      year_field.select(year)
      month_field.select(month)
    end
  end
end