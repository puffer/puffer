# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "puffer/version"

Gem::Specification.new do |s|
  s.name        = "puffer"
  s.version     = Puffer::VERSION
  s.authors     = ["pyromaniac"]
  s.email       = ["kinwizard@gmail.com"]
  s.homepage    = "http://github.com/puffer/puffer"
  s.summary     = %q{In Soviet Russia puffer admins you}
  s.description = %q{Admin interface builder}

  s.rubyforge_project = "puffer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency(%q<rails>, ["~> 3.1"])
  s.add_runtime_dependency(%q<kaminari>, [">= 0"])
  s.add_runtime_dependency(%q<orm_adapter>, [">= 0"])

  s.add_development_dependency(%q<sqlite3>, [">= 0"])
  s.add_development_dependency(%q<mongoid>, [">= 0"])
  s.add_development_dependency(%q<bson_ext>, [">= 0"])
  s.add_development_dependency(%q<rspec-rails>, [">= 0"])
  s.add_development_dependency(%q<capybara>, [">= 0"])
  s.add_development_dependency(%q<database_cleaner>, [">= 0"])
  s.add_development_dependency(%q<ammeter>, [">= 0"])
  s.add_development_dependency(%q<timecop>, [">= 0"])
  s.add_development_dependency(%q<guard>, [">= 0"])
  s.add_development_dependency(%q<guard-rspec>, [">= 0"])
  s.add_development_dependency(%q<rb-inotify>, [">= 0"])
  s.add_development_dependency(%q<libnotify>, [">= 0"])
  s.add_development_dependency(%q<forgery>, [">= 0"])
  s.add_development_dependency(%q<fabrication>, [">= 0"])
  s.add_development_dependency(%q<nested_set>, [">= 0"])

  s.add_development_dependency(%q<devise>, [">= 0"])
  s.add_development_dependency(%q<clearance>, [">= 0"])

  s.add_development_dependency(%q<carrierwave>, [">= 0"])
  s.add_development_dependency(%q<mini_magick>, [">= 0"])
end
