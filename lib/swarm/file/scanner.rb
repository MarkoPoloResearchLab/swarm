module Swarm
  module File
    # :nodoc:
    class Scanner
      attr_reader :total_lines, :total_matches, :histogram

      def initialize(pattern:)
        @pattern = pattern

        @total_lines = 0
        @total_matches = 0
        @histogram = {}
      end

      def run(payload:)
        @payload = payload
        fail ArgumentError, "Payload must have the following keys: #{expected_payload_keys}" unless payload_valid?

        match.to_hash
      end

      def to_hash
        {
          unique_key: :file_name,
          file_name: file_name,
          part: part,
          last?: last?,
          total_lines: total_lines,
          total_matches: total_matches,
          histogram: histogram
        }
      end
      alias_method :to_h, :to_hash

      private

        attr_reader :payload, :pattern

        def match
          file.seek(position)
          until end?
            line = file.readline
            @total_lines = @total_lines.next
            matches = line.scan(%r{#{pattern}}).flatten
            next if matches.empty?

            @total_matches = @total_matches.next
            ditribution = matches.each_with_object(Hash.new(0)) { |item, hash| hash[item] = hash[item].next }
            @histogram.merge!(ditribution) { |_key, oldval, newval| newval + oldval }
          end
          file.close

          self
        end

        def expected_payload_keys
          %i(unique_key file_name)
        end

        def payload_valid?
          expected_payload_keys.all? { |m| payload.key?(m) }
        end

        def defaults
          {
            part: 0,
            last?: true,
            pattern: '.*',
            position: 0,
            buffer_size: 128_000
          }
        end

        def working_payload
          @working_payload ||= defaults.merge(payload)
        end

        def end_position
          position + buffer_size
        end

        def file
          @file ||= ::File.open(file_name)
        end

        def end?
          file.tell == end_position || file.eof?
        end

        def method_missing(method_id, *args)
          return super unless working_payload.key?(method_id)

          working_payload[method_id]
        end
    end
  end
end
