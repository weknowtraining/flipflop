# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flipflop/version"

Gem::Specification.new do |s|
  s.name        = "flipflop"
  s.version     = FlipFlop::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Annesley", "Rolf Timmermans", "Jippe Holwerda"]
  s.email       = ["paul@annesley.cc", "rolftimmermans@voormedia.com", "jippeholwerda@voormedia.com"]
  s.homepage    = "https://github.com/voormedia/flipflop"
  s.summary     = %q{A feature flipflopper for Rails web applications.}
  s.description = %q{Declarative API for specifying features, switchable in declaration, database and cookies.}
  s.license  = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("activesupport", ">= 3.0", "< 5")
  s.add_dependency("i18n")

  s.add_development_dependency("rspec", "~> 2.5")
  s.add_development_dependency("rspec-its")
  s.add_development_dependency("rake")
  s.add_development_dependency("rack")
  s.add_development_dependency("actionpack", ">= 3.0", "< 5")
end
