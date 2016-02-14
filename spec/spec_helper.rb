require 'rubygems'
require 'bundler'
require 'rspec'

require 'bundler/setup'
Bundler.setup

RSpec.configure do |config|
  config.color = true
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'pry'
require 'swarm'
