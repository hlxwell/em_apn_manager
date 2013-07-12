# encoding: UTF-8

require 'logger'

module EventMachine
  module ApnManager
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger=(new_logger)
      @logger = new_logger
    end
  end
end
