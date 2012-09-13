require "rspec"

module ElabsMatchers
  require "active_support/core_ext/hash/indifferent_access"
  require "active_support/inflector"
  require "rspec"

  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "elabs_matchers/**/*.rb")].each do |file|
    require file unless file.split("/").last == "version.rb"
  end

  RSpec.configure do |config|
  end
end
