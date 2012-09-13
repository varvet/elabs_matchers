module ElabsMatchers
  module Matchers
    module HaveFlash
      extend RSpec::Matchers::DSL
      rspec :type => :request

      ##
      #
      # Asserts if the supplied flash notice exists or not
      #
      # @param [String] text              The content of the flash notice
      #
      # Example:
      # page.should have_flash_notice("Success")

      matcher :have_flash_notice do |text|
        match { |page| page.has_css?("#flash.notice, #flash .notice, .flash.notice", :text => text) }
        match_for_should_not { |page| page.has_no_css?("#flash.notice, #flash .notice, .flash.notice", :text => text) }
        failure_message_for_should { |page| "expected flash notice to be '#{text}' but was '#{page.find('#flash.notice, #flash .notice, .flash.notice').text}'" }
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

      matcher :have_flash_alert do |text|
        match { |page| page.has_css?("#flash.alert, #flash .alert, .flash.alert", :text => text) }
        match_for_should_not { |page| page.has_no_css?("#flash.alert, #flash .alert, .flash.alert", :text => text) }
        failure_message_for_should { |page| "expected flash alert to be '#{text}' but was '#{page.find("#flash.alert, #flash .alert, .flash.alert").text}'" }
        failure_message_for_should_not { |page| "expected flash alert not to be '#{text}' but it was" }
      end
    end
  end
end
