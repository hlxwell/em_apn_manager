# encoding: UTF-8

require 'base64'
require 'em-hiredis'
require "em_apn_manager/client"
require "em_apn_manager/notification"

module EventMachine
  module ApnManager
    class Manager
      $connection_pool = {}

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
        # TODO, should store Rails.root/tmp/certs and this folder should be protected.
        FileUtils.mkdir_p "certs"
        filename = Base64.encode64(cert_content)[0..50]
        filename = File.join "certs", filename
        return filename if File.exist?(filename)

        File.open filename, "w+" do |f|
          f.write cert_content
        end
        filename
      end
    end
  end
end
