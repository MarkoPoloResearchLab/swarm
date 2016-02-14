module Swarm
  # :nodoc:
  class Dispatcher < Swarm::Base
    def initialize(**args)
      fail ArgumentError, ':splitter is a required argument' unless args.key? :splitter

      splitter = args.delete(:splitter)
      fail ArgumentError, 'Splitter must respond to :each' unless splitter.respond_to? :each

      @splitter = splitter
      super args if defined?(super)
    end

    def process
      splitter.each do |chunk|
        chunks_mq << chunk
      end
      true
    end

    private

      attr_reader :splitter
  end
end
