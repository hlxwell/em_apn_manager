require 'thor'
require 'eventmachine'
require 'em_apn_manager/logger'
if defined?(Rails)
  require 'em_apn_manager/engine'
end

module EventMachine
  module ApnManager
    extend self
    attr_accessor :config

    def push_notification options = {}
      # FIXME Check options
      $apn_manager_redis.publish "push-notification", {
        cert: options[:cert],
        token: options[:token],
        message: options[:message]
      }.to_json
    end
  end
end
