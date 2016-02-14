#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup

require_relative 'lib/swarm'

# file = '/Users/vadymtyemirov/Downloads/browser_agent.csv'
file_name = 'example/head_browser_agent.csv'
# pattern = 'Chrome/(\d+)'
# pattern = '\b(Chrome)/(\d+)'
chunks_mq_name = 'chunks'
# results_mq_name = 'results'

splitter = Swarm::File::Splitter.new(file_name: file_name)
# processor = Swarm::Log.new(pattern: pattern)

# dispatcher = Swarm::Dispatcher.new(file_name: file_name, pattern: pattern, queue_name: chunks_mq_name)
dispatcher = Swarm::Dispatcher.new(splitter: splitter, chunks_mq_name: chunks_mq_name)
dispatcher.process

# Process.kill("HUP", pid)
