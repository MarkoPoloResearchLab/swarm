#!/usr/bin/env ruby

require_relative 'lib/text_file_analyzer'

# file = '/Users/vadymtyemirov/Downloads/browser_agent.csv'
file_name = 'example/head_browser_agent.csv'
pattern = 'Chrome/(\d+)'
# pattern = '\b(Chrome)/(\d+)'

analyzer = TextFile::Analyzer.new(file_name, pattern)
analyzer.process

puts "Lines processed: #{analyzer.lines_total}"
puts "Lines matching '#{pattern}': #{analyzer.lines_match} (#{analyzer.match_percentage}%)"
puts analyzer.chart
puts analyzer.table(headers: ['version', '#'])
puts analyzer.cluster_table(headers: ['version', '#'])
