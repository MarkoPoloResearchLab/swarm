require 'logger'

module Concerns
  module Loggable
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def logger
        if @logger.nil?
          @logger = Logger.new STDOUT
          @logger.level = Logger::DEBUG
          @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        end
        @logger
      end
    end
  end
end
