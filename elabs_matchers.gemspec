# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "elabs_matchers/version"

Gem::Specification.new do |s|
  s.name        = "elabs_matchers"
  s.version     = ElabsMatchers::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Everyone at Elabs"]
  s.email       = ["dev@elabs.se"]
  s.homepage    = "http://github.com/elabs/elabs_matchers"
  s.summary     = %q{Provides a set of useful rspec matchers}
  s.description = %q{Provides a set of useful rspec matchers to be used with RSpec and/or Capybara}

  s.rubyforge_project = "elabs_matchers"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rspec-core"
  s.add_dependency "rspec-expectations"

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("capybara")
  s.add_development_dependency("yard")
  s.add_development_dependency("activesupport")
  s.add_development_dependency("activemodel")
  s.add_development_dependency("pry")
end
