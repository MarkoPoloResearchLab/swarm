#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup

require_relative 'lib/swarm'

Swarm::Drone.land
