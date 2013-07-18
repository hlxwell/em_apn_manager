# encoding: UTF-8

require 'thor'
require 'redis'
require 'yaml'
require 'yajl'
require 'yajl/json_gem'
require 'em_apn_manager'
require "em_apn_manager/manager"
require "em_apn_manager/apn_server"

ENV["APN_CERT"] ||= File.join(File.dirname(__FILE__), "..", "..", "certs", "cert.pem")

$apn_manager_redis = nil

module EventMachine
  module ApnManager
    class CLI < Thor
      class_option :config,       :aliases => ["-c"], :type => :string
      class_option :environment,  :aliases => ["-e"], :type => :string
      class_option :redis,        :aliases => ["-r"], :type => :string

      ### 3 ways to specify the redis
      # 1. config yml file
      # 2. pass redis-url is 'redis://username:password@host:port/database'
      # like `redis://test:test@localhost:6379/em_apn_manager`
      #
      def initialize(args = [], opts = [], config = {})
        super(args, opts, config)

        redis_config = options[:redis]
        if redis_config.nil?
          # read the environment var.
          @environment = ENV["RAILS_ENV"] || "development"
          @environment = options[:environment] if %w{test development production}.include? options[:environment]

          # Read config option, or use default config yml
          config_path = options[:config] || File.join(".", "config", "em_apn_manager.yml")
          if config_path && File.exists?(config_path)
            EM::ApnManager.config = Thor::CoreExt::HashWithIndifferentAccess.new(YAML.load_file(config_path))
            redis_config = EM::ApnManager.config[@environment]
          end

          # default redis
          redis_config ||= "redis://localhost:6379/em_apn_manager"
        end

        # create redis connection
        $apn_manager_redis = Redis.new url: redis_config
      end

      desc "server", "Start manager server."
      option :daemon,       :aliases => ["-d"], :type => :boolean
      option :pid_file,     :aliases => ["-p"], :type => :string
      def server
        daemonize if options[:daemon]
        write_pid_file(options[:pid_file]) if options[:pid_file]

        EM::ApnManager.logger.info("Starting APN Manager")
        EM.run { EM::ApnManager::Manager.run }
      end

      ### For Testing ##################################################
      desc "push_test_message", "Push test messages to server."
      # if message is DISCONNECT, mock apns will disconnect.
      def push_test_message
        EM::ApnManager.push_notification({
          env: @environment,
          cert: File.read(ENV["APN_CERT"]), # test cert
          # iPhone5
          # "D42A6795D0C6C0E5F3CC762F905C3654D2A07E72D64CDEC1E2F74AC43C4CC440"
          # iPhone4
          # "BACF565FB283E9F7378D5A0AEBCBCB49A4D7834AED8FAC7FE0CB28144D94E456"
          # My iPhone4s
          # "0F93C49EAAF3544B5218D2BAE893608C515F69B445279AB2B17511C37046C52B"
          token: ["0F93C49EAAF3544B5218D2BAE893608C515F69B445279AB2B17511C37046C52B"].sample,
          message: "Hahahaha I am going to spam you. #{rand * 100}"
        })
      end

      desc "mock_apn_server", "Start a mock apple APNS Server."
      def mock_apn_server
        EM::ApnManager.logger.info("Starting Mock APN Server")
        EM.run { EM.start_server("127.0.0.1", 2195, EM::ApnManager::ApnServer) }
      end

      private

      # Daemonize process (ruby >= 1.9 only)
      # @return [void] Ruby ~>1.8
      # @return [0] Ruby 1.9+ (see Process::daemon)
      # @raise [Errno] on failure
      def daemonize
        if Process.respond_to?(:daemon)
          Process.daemon(true, true)
        else
          Kernel.warn "Running process as daemon requires ruby >= 1.9"
        end
      end

      # Save worker's pid to file
      # @return [void]
      def write_pid_file(path = nil)
        File.open(path, 'w'){ |f| f << Process.pid } if path
      end
    end
  end
end
