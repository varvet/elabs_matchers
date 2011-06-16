module ElabsMatchers
  module Cucumber
    module Common
      ##
      #
      # Matches a comma or the word 'and'.
      #
      # Example:
      # ,
      # and

      LIST_SEPARATOR = %r{(?:,\s|\sand\s)}

      ##
      #
      # Matches a list seperated by LIST_SEPARATOR (, or the word 'and')
      #
      # Example:
      # "foo", "bar" and "baz"

      LIST_REGEXP = %r{(?:"(?:[^\"]*)"#{LIST_SEPARATOR}?)+}

    private

      def human_list_to_array(list)
        list.gsub('"', '').split(LIST_SEPARATOR)
      end
    end
  end
end

module Cucumber
  include ElabsMatchers::Cucumber::Common
end

RSpec.configure do |config|
  config.include ElabsMatchers::Cucumber::Common
end

if defined? World
  ##
  #
  # Transforms a cucumber step so that the list it includes turns into an array
  #
  # Example:
  # Step: Then I should see "Bart", "Lisa" and "Homer"
  # Definition: 
  #   Then /^I should see (#{LIST_REGEXP})$/ do |names|
  #     # names == ["Bart", "Lisa", "Homer"]
  #   end

  Transform /^#{LIST_REGEXP}$/ do |list|
    ElabsMatchers::Cucumber::Common::human_list_to_array(list)
  end

  World(ElabsMatchers::Cucumber::Common)
end
