require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'em-hiredis'
require 'json'
require 'yajl'
require 'logger'
require 'base64'
require 'em_apn_manager'

################################################

EM.run do
  EM::ApnManager::Manager.run
end
