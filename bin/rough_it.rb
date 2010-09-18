#!/usr/bin/env ruby

require 'yaml'
require 'pp'
require File.join(File.dirname(__FILE__), '..', 'lib', 'resourceful')

resources = [
             { :name => "X", :time_worked => 0, :last_worked => "" },
             { :name => "Y", :time_worked => 0, :last_worked => "" },
             { :name => "Z", :time_worked => 0, :last_worked => "" }
            ]

complex_schedule = YAML::load(open(File.join(File.dirname(__FILE__), '..', 'test', 'complex_schedule.yml')))
r = Resourceful.new(complex_schedule, resources)

pp r.do_scheduling.sort { |a,b| a[:task] <=> b[:task] }

pp resources
pp complex_schedule
