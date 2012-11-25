# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "puffer/version"

Gem::Specification.new do |s|
  s.name        = "puffer"
  s.version     = Puffer::VERSION
  s.authors     = ["pyromaniac"]
  s.email       = ["kinwizard@gmail.com"]
  s.homepage    = "http://github.com/puffer/puffer"
  s.summary     = "In Soviet Russia puffer admins you"
  s.description = "Admin interface builder"

  s.rubyforge_project = "puffer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rails', '>= 3.1'
  s.add_runtime_dependency 'orm_adapter', '>= 0.4'
  s.add_runtime_dependency 'kaminari'

  s.add_development_dependency 'mongoid', '>= 3.0'
  s.add_development_dependency 'sqlite3'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ammeter'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'

  if RUBY_PLATFORM =~ /darwin/i
    s.add_development_dependency 'rb-fsevent'
  else
    s.add_development_dependency 'libnotify'
    s.add_development_dependency 'rb-inotify'
  end

  s.add_development_dependency 'forgery'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'nested_set'

  s.add_development_dependency 'devise'
  s.add_development_dependency 'clearance'

  s.add_development_dependency 'carrierwave'
  s.add_development_dependency 'mini_magick'
end
