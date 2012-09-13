require "rspec"

module ElabsMatchers
  require "active_support/core_ext/hash/indifferent_access"
  require "active_support/core_ext/object/blank"
  require "active_support/inflector"
  require "rspec"

  relative_file_path = lambda do |files|
    base_dir = File.expand_path(File.dirname(__FILE__))
    File.join(base_dir, "elabs_matchers", files)
  end

  require relative_file_path["extensions/module"]
  Dir[relative_file_path["{helpers,matchers}/*.rb"]].each { |f| require f }

  RSpec.configure do |config|
  end
end
