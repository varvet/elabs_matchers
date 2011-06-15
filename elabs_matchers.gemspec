# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "elabs_matchers/version"

Gem::Specification.new do |s|
  s.name        = "elabs_matchers"
  s.version     = ElabsMatchers::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nicklas Ramhöj"]
  s.email       = ["dev+ramhoj@elabs.se"]
  s.homepage    = ""
  s.summary     = %q{Provides a set of usefull rspec matchers}
  s.description = %q{Provides a set of usefull rspec matchers to be used with RSpec and/or Capybara}

  s.rubyforge_project = "elabs_matchers"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("rspec")
  s.add_development_dependency("capybara")
  s.add_development_dependency("yard")
end
