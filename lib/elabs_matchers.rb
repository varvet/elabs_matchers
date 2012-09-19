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
    attr_accessor :header_selector, :header_selector_type
    attr_accessor :attribute_selector, :attribute_selector_type
    attr_accessor :flash_notice_selector, :flash_notice_selector_type, :flash_alert_selector, :flash_alert_selector_type
    attr_accessor :form_errors_on_selector
    attr_accessor :image_selector, :image_selector_type
    attr_accessor :table_row_selector

    ##
    #
    # Configure ElabsMatchers to suit your needs. The spec/spec_helper.rb
    # file is a good place to put your configurations in.
    #
    #     ElabsMatchers.configure do |config|
    #       config.header_selector = "//h1"
    #       config.header_selector_type = :xpath
    #       config.image_selector = lambda { |src| "img[src='#{src}']" }
    #     end
    #
    # === Configurable options
    #
    # [header_selctor = String]               The selector to use when finding header tags (Default: "h1,h2")
    # [header_selector_type = Symbol]         The type of selector to use, :css or :xpath (Default: :css)
    #
    # [image_selctor = lamda]                 The selector to use when finding images (Default: see matcher)
    # [image_selector_type = Symbol]          The type of selector to use, :css or :xpath (Default: :css)
    #
    # [attribute_selector = lambda]           A lambda that takes label and value as arguments and return a selector (Default: see matcher)
    # [attribute_selector_type = Symbol]      The type of selector to use, :css or :xpath (Default: :xpath)
    #
    # [flash_notice_selector = String]        The selector to use when finding the flash notice (Default: "#flash.notice, #flash .notice, .flash.notice")
    # [flash_notice_selector_type = Symbol]   The type of selector to use, :css or :xpath (Default: :css)
    # [flash_alert_selector = String]         The selector to use when finding the flash alert (Default: "#flash.alert, #flash .alert, .flash.alert")
    # [flash_alert_selector_type = Symbol]    The type of selector to use, :css or :xpath (Default: :css)
    #
    # [form_errors_on_selector = String]      A xpath expression to be used when finding associated error notices (Default: see matcher)
    #
    # [table_row_selector = lambda]           A lambda that takes table row return a selector (Default: see matcher)

    def configure
      yield self
    end

    ##
    #
    # Reset Elabs matchers to use the default configuration.

    def use_default_configuration!
      configure do |config|
        config.header_selector = "h1,h2"
        config.header_selector_type = :css

        config.image_selector = nil
        config.image_selector_type = :css

        config.attribute_selector = nil
        config.attribute_selector_type = :xpath

        config.flash_notice_selector = "#flash.notice, #flash .notice, .flash.notice"
        config.flash_notice_selector_type = :css
        config.flash_alert_selector = "#flash.alert, #flash .alert, .flash.alert"
        config.flash_alert_selector_type = :css

        config.form_errors_on_selector = nil

        config.table_row_selector = nil
      end
    end
  end
end

ElabsMatchers.use_default_configuration!
