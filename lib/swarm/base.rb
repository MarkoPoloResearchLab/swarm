require 'redis_reliable_queue'

module Swarm
  # :nodoc:
  class Base
    include Concerns::Loggable

    def initialize(chunks_mq_name:, results_mq_name:)
      @chunks_mq_name = chunks_mq_name
      @results_mq_name = results_mq_name
    end

    private

      def results_mq
        @results_mq ||= Redis::ReliableQueue.new(redis: redis, queue_name: @results_mq_name)
      end

      def chunks_mq
        @chunks_mq ||= Redis::ReliableQueue.new(redis: redis, queue_name: @chunks_mq_name)
      end

      def redis
        @redis ||= Redis.new
      end
  end
end
