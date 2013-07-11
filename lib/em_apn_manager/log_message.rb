module EM
  module ApnManager

    class LogMessage
      def initialize(response)
        @response = response
      end

      def log
        EM::ApnManager.logger.info(@response.to_s)
      end
    end
  end
end
