require 'facter'

module Swarm
  class LocalDistributor
    class << self
      def launch(number: cpus)
        fail ArgumentError, 'Code block must be supplied' unless block_given?

        @number = number

        parallelization do
          yield
        end
      end

      private

        attr_accessor :number

        def parallelization
          runners = parallelize do
            yield
          end

          distribute(runners)
        end

        def distribute(runners)
          runners.each do |runner|
            case runner
            when Thread
              runner.join
            else
              Process.detach(runner)
            end
          end
        end

        def parallelize
          number.times.map do
            running_in_parallel do
              yield
            end
          end
        end

        def running_in_parallel
          case (RUBY_ENGINE)
          when 'jruby'
            Thread.new do
              yield
            end
          when 'ruby'
            fork do
              yield
            end
          end
        end

        def cpus
          Facter.value(:processorcount).to_i
        end
    end
  end
end
