require_relative 'chunk'

module Swarm
  module Db
    # :nodoc:
    class Splitter
      def initialize(table_name:)
        fail ArgumentError, "Table '#{table_name}' doesn't exist" unless File.exist? table_name

        @table_name = table_name
        @table_size = File.size(table_name)
      end

      def each
        return enum_for(:each) unless block_given?

        chunk = Chunk.new(total_size: table_size)
        buffer_size = chunk.size

        file = File.open(table_name)
        until file.eof?
          current_position = file.tell
          goto = current_position + buffer_size
          file.seek(goto)

          begin
            increment = file.readline.length
          rescue EOFError
            buffer_size = table_size - current_position
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

        attr_accessor :table_name, :table_size

        def addendum
          {
            unique_key: :table_name,
            table_name: table_name
          }
        end
    end
  end
end
