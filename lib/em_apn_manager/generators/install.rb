# encoding: UTF-8

module EventMachine
  module ApnManager
    class Install < Rails::Generators::Base
      desc "Install EventMachine APN Manager."
      source_root File.expand_path('../templates', __FILE__)
      def create_config
        say "Create Configure file to project...", :yellow
        copy_file "em_apn_manager.yml", "config/em_apn_manager.yml"
      end
    end
  end
end
