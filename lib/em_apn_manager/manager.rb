module EventMachine
  module ApnManager
    class Manager
      $connection_pool = {} # Connection Pool

      def self.run options = {}
        self.new.tap do |manager|
          manager.run options
        end
      end # end of run

      def run options = {}
        @redis = EM::Hiredis.connect

        @redis.pubsub.subscribe('push-notification') do |msg|
          msg_hash = Yajl::Parser.parse(msg) # might be some wrong json
          cert_filename = save_cert_to_file msg_hash["cert"]
          key_filename = save_cert_to_file msg_hash["key"]
          client = $connection_pool[cert_filename]

          # Create client connection if doesn't exist in pool.
          if client.nil?
            client = EM::ApnManager::Client.new(options.merge({cert: cert_filename, key: key_filename}))
            $connection_pool[cert_filename] = client # Store the connection to pool
          end

          notification = EM::ApnManager::Notification.new(msg_hash["token"], :alert => msg_hash["message"])
          # send message directly if connection was connected.
          if client.connected?
            client.deliver(notification)
          else # if connection not connected, set callback block to deliver notification, and connect to apple server.
            client.on_open do
              client.deliver(notification)
            end
            client.connect
          end
        end
      end

      private

      def save_cert_to_file cert_content
        filename = Base64.encode64(cert_content)[0..50]
        return filename if File.exist?(filename)

        File.open "certs/#{filename}", "w+" do |f|
          f.write cert_content
        end
        filename
      end
    end
  end
end
