# encoding: UTF-8

require 'base64'
require 'yajl'
require 'yajl/json_gem'
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

      # options = {gateway, port}
      def run options = {}
        @redis = EM::Hiredis.connect options[:redis]
        @redis.on :connected do
          puts "connected"
        end
        @redis.on :closed do
          puts "closed"
        end
        @redis.on :disconnected do
          puts "disconnected"
        end
        @redis.on :reconnect_failed do
          puts "reconnect_failed"
        end

        ### launch a new connect to apple when detected any pushs.
        @redis.pubsub.subscribe('push-notification') do |msg|
          msg_hash = Yajl::Parser.parse(msg) # FIXME might be some wrong json

          # save the cert to local first, since the start_tls read from file.
          cert_filename = save_cert_to_file msg_hash["cert"]

          # cert filename is a key for connection pool
          client = $connection_pool[cert_filename]

          ### Create client connection if doesn't exist in pool.
          if client.nil?
            opts = {:env => msg_hash["env"], :cert => cert_filename}
            client = EM::ApnManager::Client.new(options.merge(opts))
            # Store the connection to pool
            $connection_pool[cert_filename] = client
          end

          ### send message directly if connection was connected.
          ### TODO you can bind on_close, on_open, on_error events.
          notification = EM::ApnManager::Notification.new(msg_hash["token"], :alert => msg_hash["message"])
          if client.connected?
            client.deliver(notification)
          else
            # if connection not connected, set callback block to deliver notification, and connect to apple server.
            client.on_open do
              client.deliver(notification)
            end
            client.connect
          end
        end
      end

      private

      # NOTICE should not put the 'certs' folder to a downloadable place.
      def save_cert_to_file cert_content
        FileUtils.mkdir_p "certs"

        filename = Digest::SHA1.hexdigest(cert_content)
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
