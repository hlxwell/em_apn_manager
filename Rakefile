# encoding: UTF-8
require 'rubygems'

begin
  require 'bundler/setup'
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rdoc/task'
require 'rake/testtask'

# jeweler
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mail_engine"
  gem.homepage = "http://github.com/hlxwell/em_apn_manager"
  gem.license = "MIT"
  gem.summary = %Q{EventMachine multiple APNs connections Management Solution. You can use multiple cert and connection to apple's APNs server.}
  gem.description = %Q{EventMachine multiple APNs connections Management Solution. You can use multiple cert and connection to apple's APNs server.}
  gem.email = "hlxwell@gmail.com"
  gem.authors = ["michael he"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)

  gem.add_runtime_dependency "thor",         "~> 0.16"
  gem.add_runtime_dependency "eventmachine", ">= 1.0.0.beta.3"
  gem.add_runtime_dependency "yajl-ruby",    ">= 0.8.2"
  gem.add_runtime_dependency "redis",        ">= 2.2.0"
  gem.add_runtime_dependency "em-hiredis",   ">= 0.2.1"
  gem.add_development_dependency "rspec", "~> 2.6.0"
end
Jeweler::RubygemsDotOrgTasks.new

# # Rcov
# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
# end
# 
# # Reek tasks
# require 'reek/rake/task'
# Reek::Rake::Task.new do |t|
#   t.fail_on_error = true
#   t.verbose = false
#   t.source_files = 'lib/**/*.rb'
# end
# 
# # test tasks
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib' << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end
# task :default => :test

# yard tasks
require 'yard'
YARD::Rake::YardocTask.new
