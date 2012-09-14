require "rspec"

module ElabsMatchers
  require "active_support/core_ext/hash/indifferent_access"
  require "active_support/core_ext/object/blank"
  require "active_support/core_ext/array/conversions"
  require "active_support/inflector"
  require "rspec"

  require "elabs_matchers/extensions/module"
  require "elabs_matchers/helpers/fixtures"
  require "elabs_matchers/helpers/normalize_keys"
  require "elabs_matchers/helpers/reload_record"
  require "elabs_matchers/helpers/select_year_and_month"

  require "elabs_matchers/matchers/allow"
  require "elabs_matchers/matchers/contain_hash"
  require "elabs_matchers/matchers/have_attribute"
  require "elabs_matchers/matchers/have_fields"
  require "elabs_matchers/matchers/have_flash"
  require "elabs_matchers/matchers/have_form_errors_on"
  require "elabs_matchers/matchers/have_header"
  require "elabs_matchers/matchers/have_image"
  require "elabs_matchers/matchers/have_table_row"
  require "elabs_matchers/matchers/only_include"
  require "elabs_matchers/matchers/persist"
end
