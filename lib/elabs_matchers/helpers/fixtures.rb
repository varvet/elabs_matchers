module ElabsMatchers
  module Helpers
    module Fixtures
      rspec

      ##
      #
      # Opens a file from the fixtures directory.
      #
      # @param [String] path      A file name, relative to the fixtures folder.
      #
      # Example:
      # fixture_file("file.txt")
      #

      def fixture_file(path)
        root = if defined?(Rails) then Rails.root else "../../../spec/" end
        File.open(File.expand_path("#{root}/fixtures/#{path}", File.dirname(__FILE__)))
      end
    end
  end
end
