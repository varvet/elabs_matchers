module ElabsMatchers
  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "elabs_matchers/**/*.rb")].each do |file|
    require file unless file.split("/").last == "version.rb"
  end
end
