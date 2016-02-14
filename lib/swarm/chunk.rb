require 'facter'

module Swarm
  # :nodoc:
  class Chunk
    def initialize(total_size:)
      fail ArgumentError, ':total_size must be greater than 0' unless total_size > 0

      @total_size = total_size
      @part = 0
    end

    def next(position:, buffer_size:)
      @part += 1
      @position = position
      @buffer_size = buffer_size
    end

    def size
      return (total_size / cpus).ceil if total_size < default_size

      default_size
    end

    def to_hash
      {
        position: position,
        buffer_size: buffer_size,
        part: part,
        last?: last?
      }
    end
    alias_method :to_h, :to_hash

    private

      attr_reader :total_size, :part, :position, :buffer_size

      def cpus
        Facter.value(:processorcount).to_i
      end

      def default_size
        1_048_576
      end

      def last?
        return false unless [position, buffer_size].all?

        position + buffer_size >= total_size
      end
  end
end
