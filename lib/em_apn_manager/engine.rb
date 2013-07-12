module EventMachine
  module ApnManager
    class Engine < ::Rails::Engine
      generators do
        require 'em_apn_manager/generators/install.rb'
      end
    end
  end
end