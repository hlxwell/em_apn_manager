# encoding: UTF-8

require "em_apn_manager/error_response"

module EventMachine
  module ApnManager
    class Connection < EM::Connection
      attr_reader :client

      def initialize(*args)
        super
        @client = args.last
        @disconnected = false
      end

      def disconnected?
        @disconnected
      end

      def post_init
        EM::ApnManager.logger.info("Connecting...")

        start_tls(
          :private_key_file => client.cert,
          :cert_chain_file  => client.cert,
          :verify_peer      => false
        )
      end

      def connection_completed
        EM::ApnManager.logger.info("Connection completed")

        client.open_callback.call if client.open_callback
      end

      def receive_data(data)
        data_array = data.unpack("ccN")
        error_response = ErrorResponse.new(*data_array)
        EM::ApnManager.logger.warn(error_response.to_s)
        client.error_callback.call(error_response) if client.error_callback
      end

      def unbind
        EM::ApnManager.logger.info("Connection closed")

        @disconnected = true
        client.close_callback.call if client.close_callback
      end
    end
  end
end
