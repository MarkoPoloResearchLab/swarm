#!/usr/bin/env ruby

require 'pry'
require_relative 'lib/text_file_analyzer'

# file = '/Users/vadymtyemirov/Downloads/browser_agent.csv'
file_name = 'example/head_browser_agent.csv'
pattern = 'Chrome/(\d+)'
# pattern = '\b(Chrome)/(\d+)'
chunks_mq_name = 'chunks'
results_mq_name = 'results'

# dispatcher = TextFile::Dispatcher.new(file_name: file_name, pattern: pattern, queue_name: chunks_mq_name)
# dispatcher.process

aggregator = TextFile::Aggregator.new(queue_name: results_mq_name)
aggregator.process

# Process.kill("HUP", pid)
