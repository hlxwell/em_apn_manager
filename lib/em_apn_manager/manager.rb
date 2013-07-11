module EM
  module ApnManager
    class Manager
      $connection_pool = {} # Connection Pool

      def self.run
        @redis = EM::Hiredis.connect
        @redis.pubsub.subscribe('push-notification') do |msg|
          msg_hash = JSON.parse(msg) # might be some wrong json
          connection_key = Base64.encode64(msg_hash["cert"])
          client = $connection_pool[connection_key]

          # Create client connection if doesn't exist in pool.
          if client.nil?
            client = EM::ApnManager::Client.new(:gateway => "127.0.0.1", cert: msg_hash["cert"], key: msg_hash["key"])
            $connection_pool[connection_key] = client # Store the connection to pool
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
      end # end of run

    end
  end
end
