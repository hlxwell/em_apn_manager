# encoding: UTF-8

# Mock Apple push server for testing.
module EventMachine
  module ApnManager
    module ApnServer
      def post_init
        EM::ApnManager.logger.info("Received a new connection")
        @data  = ""

        start_tls(
          :cert_chain_file  => ENV["APN_CERT"],
          :private_key_file => ENV["APN_CERT"],
          :verify_peer      => false
        )
      end

      def ssl_handshake_completed
        EM::ApnManager.logger.info("SSL handshake completed")
      end

      def receive_data(data)
        @data << data

        # Try to extract the payload header
        headers = @data.unpack("cNNnH64n")
        return if headers.last.nil?

        # Try to grab the payload
        payload_size = headers.last
        payload = @data[45, payload_size]
        return if payload.length != payload_size

        @data = @data[45 + payload_size, -1] || ""

        process(headers, payload)
      end

      def process(headers, payload)
        message = "APN RECV #{headers[4]} #{payload}"
        EM::ApnManager.logger.info(message)

        args = Yajl::Parser.parse(payload)

        # If the alert is 'DISCONNECT', then we fake a bad payload by replying
        # with an error and disconnecting.
        if args["aps"]["alert"] == "DISCONNECT"
          EM::ApnManager.logger.info("Disconnecting")
          send_data([8, 1, 0].pack("ccN"))
          close_connection_after_writing
        end
      end

      def unbind
        EM::ApnManager.logger.info("Connection closed")
      end
    end
  end
end
