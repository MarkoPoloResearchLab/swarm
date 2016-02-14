#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup

require_relative 'lib/swarm'

chunks_mq_name = 'chunks'
results_mq_name = 'results'
pattern = 'Chrome/(\d+)'

log_processor = Swarm::FileScanner.new(pattern: pattern)

Swarm::LocalDistributor.launch do
  worker = Swarm::Drone.new(processor: log_processor, chunks_mq_name: chunks_mq_name, results_mq_name: results_mq_name)
  worker.start
end
