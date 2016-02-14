require 'cfpropertylist'
require 'ascii_charts'
require 'terminal-table'
require 'facter'
require 'pry'
require 'parallel'
require 'active_support/core_ext/hash/deep_merge'
require 'ai4r'
require 'redis/connection/hiredis'
require 'redis_reliable_queue'
require_relative 'log'

module TextFile
  # :nodoc:
  class Analyzer
    attr_reader :lines_match, :histogram, :lines_total

    def initialize(file_name, pattern)
      fail ArgumentError, "File #{file_name} doesn't exist" unless File.exist? file_name

      @file_name = file_name
      @file_size = File.size(file_name)

      @pattern = pattern
      @lines_match = 0
      @lines_total = 0
      @histogram = {}
      @thread_queue = []
    end

    def process
      parallel_process

      result = thread_queue.reduce do |memo, element|
        memo.deep_merge(element) { |_key, oldval, newval| newval + oldval }
      end
      @lines_total = result[:total_lines]
      @lines_match = result[:total_matches]
      @histogram = result[:histogram]
    end

    def distributed_process
      split.each do |chunk|
        payload = {
            file_name: file_name,
            pattern: pattern,
            start_position: chunk.first,
            buffer_size: chunk.last
          }
        chunks_mq << payload
      end
    end

    def queue_checker
      qqq = []
      chunks_mq.process(true) do |message|
        qqq << message
      end
      qqq
    end

    def match_percentage
      ((lines_match.to_f / lines_total) * 100).round(2)
    end

    def chart
      data = histogram.to_a.sort_by { |e| e.first.to_i }
      AsciiCharts::Cartesian.new(data, title: 'Data clustering').draw
    end

    def table(headers: [])
      data = histogram.to_a.sort_by { |e| -1 * e.last }
      Terminal::Table.new(title: 'Data distribution', headings: headers, rows: data, style: { width: 80 })
    end

    def cluster_table(headers: [])
      rows = nil
      clustered_data.each do |cluster|
        rows ||= []
        rows += cluster.data_items.map(&:compact)
        rows << :separator
      end

      Terminal::Table.new(title: 'Data clustering', headings: headers, rows: rows, style: { width: 80 })
    end

    private

      attr_accessor :file_name, :pattern, :file_size, :thread_queue

      def parallel_process
        split.each_slice(max_threads) do |chunk|
          logs = Parallel.map(chunk, parallel_options) do |start, buffer_size|
              log = TextFile::Log.new(
                file_name: file_name,
                pattern: pattern,
                start_position: start,
                buffer_size: buffer_size
              )
              log.match.to_hash
            end

          logs.each { |log| thread_queue << log }
        end
      end

      def parallel_options
        case (RUBY_ENGINE)
        when 'jruby'
          { in_threads: max_threads }
        when 'ruby'
          { in_processes: max_threads }
        end
      end

      def clustered_data
        data_set = Ai4r::Data::DataSet.new(data_items: histogram.to_a)
        bisecting_k_means = Ai4r::Clusterers::BisectingKMeans.new.build(data_set, 3)
        @clustered_data ||= bisecting_k_means.centroids.sort_by { |centroid| -1 * centroid.last }.map { |centroid| bisecting_k_means.clusters.select { |cluster| cluster.data_items.assoc(centroid.first) } }.flatten
      end

      def split(buffer_size = file_chunk_size)
        result = []

        file = File.open(file_name)
        until file.eof? do
          start = file.tell
          goto = start + buffer_size
          file.seek(goto)

          begin
            increment = file.readline.length
          rescue EOFError
            buffer_size = file_size - start
          else
            buffer_size += increment
          end

          result << [start, buffer_size]
        end
        file.close

        result
      end

      def max_threads
        Facter.value(:processorcount).to_i * 2
      end

      def file_chunk_size
        file_chunk_size = 1_048_576
        file_size < file_chunk_size ? (file_size / max_threads).ceil : file_chunk_size
      end

      def results_mq
        @results_mq ||= Redis::Queue.new(redis: redis)
      end

      def chunks_mq
        @chunks_mq ||= Redis::Queue.new(redis: redis)
      end

      def redis
        @redis ||= Redis.new
      end
  end
end
