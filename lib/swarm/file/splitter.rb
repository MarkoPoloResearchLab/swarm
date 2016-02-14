require_relative '../chunk'

module Swarm
  module File
    # :nodoc:
    class Splitter
      def initialize(file_name:)
        fail ArgumentError, "File '#{file_name}' doesn't exist" unless ::File.exist?(file_name)

        @file_name = file_name
        @file_size = ::File.size(file_name)
      end

      def each
        return enum_for(:each) unless block_given?

        chunk = Chunk.new(total_size: file_size)
        buffer_size = chunk.size

        file = ::File.open(file_name)
        until file.eof?
          current_position = file.tell
          goto = current_position + buffer_size
          file.seek(goto)

          begin
            increment = file.readline.length
          rescue EOFError
            buffer_size = file_size - current_position
          else
            buffer_size += increment
          end

          chunk.next(position: current_position, buffer_size: buffer_size)
          result = addendum.merge(chunk)
          yield result
        end
        file.close
      end

      private

        attr_accessor :file_name, :file_size

        def addendum
          {
            unique_key: :file_name,
            file_name: file_name
          }
        end
    end
  end
end
