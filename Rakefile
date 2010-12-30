# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rake/rdoctask'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Puffer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "puffer"
  gem.summary = %Q{Admin interface builder}
  gem.description = %Q{In Soviet Russia puffer admins you}
  gem.email = "kinwizard@gmail.com"
  gem.homepage = "http://github.com/puffer/puffer"
  gem.authors = ["pyromaniac"]
end
