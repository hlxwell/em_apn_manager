# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "em_apn_manager"
  gem.homepage = "http://github.com/hlxwell/em_apn_manager"
  gem.license = "MIT"
  gem.summary = %Q{EventMachine multiple APNs connections Management Solution. You can use multiple cert and connection to apple's APNs server.}
  gem.description = %Q{EventMachine multiple APNs connections Management Solution. You can use multiple cert and connection to apple's APNs server.}
  gem.email = "m.he@skillupjapan.co.jp"
  gem.authors = ["Michael He"]

  # dependencies defined in Gemfile
  gem.add_runtime_dependency "thor",         "~> 0.16"
  gem.add_runtime_dependency "eventmachine", ">= 1.0.0.beta.3"
  gem.add_runtime_dependency "yajl-ruby",    ">= 0.8.2"
  gem.add_runtime_dependency "redis",        ">= 2.2.0"
  gem.add_runtime_dependency "em-hiredis",   ">= 0.2.1"
  gem.add_development_dependency "rspec", "~> 2.6.0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
#   test.rcov_opts << '--exclude "gems/*"'
# end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "em_apn_manager #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
