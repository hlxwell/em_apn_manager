# -*- mode: ruby; encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "em_apn_manager/version"

Gem::Specification.new do |s|
  s.name        = "em_apn_manager"
  s.version     = EventMachine::ApnManager::VERSION
  s.authors     = ["Michael He"]
  s.email       = ["hlxwel@gmail.com"]
  s.homepage    = "http://hlxwell.github.io"
  s.summary     = %q{EventMachine-driven Apple Push Notifications manager, support multiple certs.}
  s.rubyforge_project = "em_apn_manager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor",         "~> 0.16"
  s.add_dependency "eventmachine", ">= 1.0.0.beta.3"
  s.add_dependency "yajl-ruby",    ">= 0.8.2"
  s.add_dependency "redis",        ">= 2.2.0"
  s.add_dependency "em-hiredis",   ">= 0.2.1"
  s.add_development_dependency "rspec", "~> 2.6.0"
end
