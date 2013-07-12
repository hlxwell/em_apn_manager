# encoding: UTF-8

require "em_apn_manager/connection"

module EventMachine
  module ApnManager
    class Client
      SANDBOX_GATEWAY    = "gateway.sandbox.push.apple.com"
      PRODUCTION_GATEWAY = "gateway.push.apple.com"
      PORT               = 2195

      attr_reader :gateway, :port, :key, :cert, :connection, :error_callback, :close_callback, :open_callback

      # A convenience method for creating and connecting.
      def self.connect(options = {})
        new(options).tap do |client|
          client.connect
        end
      end

      def initialize(options = {})
        @key  = options[:key]  || ENV["APN_KEY"]
        @cert = options[:cert] || ENV["APN_CERT"]
        @port = options[:port] || PORT

        @gateway = options[:gateway] || ENV["APN_GATEWAY"]
        @gateway ||= (ENV["APN_ENV"] == "production") ? PRODUCTION_GATEWAY : SANDBOX_GATEWAY

        @connection = nil
      end

      def connect
        @connection = EM.connect(gateway, port, Connection, self)
      end

      def connected?
        !connection.nil? && !connection.disconnected?
      end

      def deliver(notification)
        if !connected?
          puts "No connection."
          return
        end
        notification.validate!
        log(notification)
        connection.send_data(notification.data)
      end

      def on_error(&block)
        @error_callback = block
      end

      def on_close(&block)
        @close_callback = block
      end

      def on_open(&block)
        @open_callback = block
      end

      def log(notification)
        EM::ApnManager.logger.info("TOKEN=#{notification.token} PAYLOAD=#{notification.payload.inspect}")
      end
    end
  end
end
