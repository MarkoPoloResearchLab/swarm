require_relative 'base'

module Swarm
  # :nodoc:
  class Drone < Swarm::Base
    include Concerns::Pidable

    class << self
      def land
        kill_all
      end

      def launch
      end
    end

    def initialize(**args)
      processor = args.delete(:processor)
      fail ArgumentError, 'Processor must respond to :run' unless processor.respond_to? :run

      @processor = processor
      super args if defined?(super)
    end

    def start
      save_pid
      logger.info "The worker has started: #{pid}"

      trap_signals
      process_queue

      true
    end

    private

      attr_reader :processor

      def trap_signals
        Signal.trap('HUP') { custom_exit }
        Signal.trap('TERM') { custom_exit }
        Signal.trap('USR1') { custom_exit }
      end

      def custom_exit
        remove_pid
        logger.info 'The worker has been interrupted'
        exit
      end

      def process_queue
        chunks_mq.process do |message|
          logger.debug "Message #{message} received"
          result = runner.run(message)

          # log = Log.new(result: message)
          # result = log.match.to_hash
          logger.debug "Message #{result} queued"
          results_mq << result
          true
        end
      end
  end
end
