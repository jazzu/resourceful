#!/usr/bin/env ruby

require 'yaml'
require 'pp'
require File.join(File.dirname(__FILE__), '..', 'lib', 'resourceful')

resources = [
             { :name => "X" },
             { :name => "Y" },
             { :name => "Z" }
            ]

complex_schedule = YAML::load(open(File.join(File.dirname(__FILE__), '..', 'test', 'complex_schedule.yml')))
r = Resourceful::Solver.new(complex_schedule, resources)

pp r.do_scheduling

pp resources
pp complex_schedule

