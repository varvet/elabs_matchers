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

  class << self
    attr_accessor :header_selector

    ##
    #
    # Configure ElabsMatchers to suit your needs. The spec/spec_helper.rb
    # file is a good place to put your configurations in.
    #
    #     ElabsMatchers.configure do |config|
    #       config.header_selector = "h1"
    #     end
    #
    # === Configurable options
    #
    # [header_selctor = String]           The css selector to use when finding header tags (Default: "h1,h2")
    #

    def configure
      yield self
    end

    ##
    #
    # Reset Elabs matchers to use the default configuration.
    #

    def use_default_configuration!
      configure do |config|
        config.header_selector = "h1,h2"
      end
    end
  end
end

ElabsMatchers.use_default_configuration!
