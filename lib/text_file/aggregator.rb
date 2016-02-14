require 'redis_reliable_queue'
require 'active_support/core_ext/hash/deep_merge'
require_relative 'payload'
require_relative '../core_ext/hash/deep_search'

module TextFile
  # :nodoc:
  class Aggregator
    include Concerns::Loggable

    def initialize(queue_name:)
      @queue_name = queue_name
    end

    def process
      results_mq.process(true) do |message|
        next unless message

        payload = unique_key = nil
        begin
          payload_object = Payload.new(message)
          unique_key = payload_object.unique_key_value
          payload = payload_object.to_h
        rescue PayloadError
          next
        end

        result = aggregated_results.key?(unique_key) ? aggregated_results[unique_key] : payload
        aggregated_results[unique_key] = result.deep_merge(payload)

        using CoreExtensions::DeepSearch
        last_payload_found = aggregated_results.all(:last?).any?

        if last_payload_found
          last_part = aggregated_results.where(last?: true).first[:part]
          all_parts = (0..last_part).to_a
          current_parts = aggregated_results.all(:parts)
          finish if (current_parts - all_parts).empty?
        end

        true
      end
    end

    private

      def finish
        logger.info "Finished processing for #{aggregated_results}"
      end

      def aggregated_results
        @aggregated_results ||= {}
      end

      def results_mq
        @results_mq ||= Redis::ReliableQueue.new(redis: redis, queue_name: @queue_name)
      end

      def redis
        @redis ||= Redis.new
      end
  end
end
