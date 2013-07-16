# encoding: UTF-8

require 'thor'
require 'redis'
require 'yaml'
require 'yajl'
require 'yajl/json_gem'
require 'em_apn_manager'
require "em_apn_manager/manager"
require "em_apn_manager/apn_server"

ENV["APN_KEY"]  ||= File.join(File.dirname(__FILE__), "..", "..", "certs", "key.pem")
ENV["APN_CERT"] ||= File.join(File.dirname(__FILE__), "..", "..", "certs", "cert.pem")

$apn_manager_redis = nil

module EventMachine
  module ApnManager
    class CLI < Thor
      class_option :config, :aliases => ["-c"], :type => :string
      class_option :environment, :aliases => ["-e"], :type => :string

      def initialize(args = [], opts = [], config = {})
        super(args, opts, config)

        # Read config option, or use default config yml
        config_path = options[:config] || File.join(".", "config", "em_apn_manager.yml")
        if config_path && File.exists?(config_path)
          EM::ApnManager.config = Thor::CoreExt::HashWithIndifferentAccess.new(YAML.load_file(config_path))
        else
          raise "No config file is specified or specified config file doesn't exist."
        end

        # read the environment var.
        @environment = "development"
        if %w{test development production}.include? options[:environment]
          @environment = ENV[:RAILS_ENV] || ENV[:APN_ENV]
        end

        # create redis connection
        $apn_manager_redis = Redis.new EM::ApnManager.config[@environment] || { host:"127.0.0.1", port:6379 }
      end

      desc "server", "Start manager server."
      # option :daemon,       :aliases => ["-d"], :type => :boolean
      # option :pid_file,     :aliases => ["-p"], :type => :string
      def server
        EM::ApnManager.logger.info("Starting APN Manager")
        EM.run { EM::ApnManager::Manager.run }
      end

      ### For Testing ##################################################
      desc "push_test_message", "Push test messages to server."
      def push_test_message
        EM::ApnManager.push_notification({
          cert: File.read(ENV["APN_CERT"]),
          key: File.read(ENV["APN_KEY"]),
          token: "fe9515ba7556cfdcfca6530235c95dff682fac765838e749a201a7f6cf3792e6",
          # if it's DISCONNECT, mock apns will disconnect.
          # message: "DISCONNECT"
          message: "Hello User##{rand * 10000}."
        })
      end

      desc "mock_apn_server", "Start a mock apple APNS Server."
      def mock_apn_server
        EM::ApnManager.logger.info("Starting Mock APN Server")
        EM.run { EM.start_server("127.0.0.1", 2195, EM::ApnManager::ApnServer) }
      end
    end
  end
end
