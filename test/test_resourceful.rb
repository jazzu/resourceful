# -*- coding: utf-8 -*-
require 'rubygems'
require 'yaml'
require 'contest'
require File.join(File.dirname(__FILE__), '..', 'lib', 'resourceful')

class ResourcefulTest < Test::Unit::TestCase

  setup do
    @schedule = [{ :task => "Restroom cleaning", :time => 1, :resources => 2 },
                 { :task => "Flyer distribution", :time => 2, :resources => 3 },
                 { :task => "Tour of the venue", :time => 3, :resources => 1 }]

    @resources = [{ :name => "Alice" },
                  { :name => "Bob" },
                  { :name => "Eve" }]

  end

  context "simple data acceptance" do
    setup do
      @rful = Resourceful::Solver.new
    end

    should "accept resource hash data" do
      @rful.resources = @resources
      assert_equal @resources, @rful.resources
    end

    should "accept schedule hash data" do
      @rful.schedule = @schedule
      assert_equal @schedule, @rful.schedule
    end

    should "accept schedule and resource hash data on creation" do
      assert_nothing_raised { rful = Resourceful::Solver.new(@schedule, @resources) }
    end
  end

  context "scheduling runs" do
    setup do
      @populated_rful = Resourceful::Solver.new(@schedule, @resources)
    end

    test "naive scheduling" do
      @naive_results = [{ :task => "Restroom cleaning", :resources => ["Bob", "Eve"] },
                        { :task => "Flyer distribution", :resources => ["Alice", "Bob", "Eve"] },
                        { :task => "Tour of the venue", :resources => ["Alice"] }]
      assert_equal @naive_results, @populated_rful.do_scheduling
    end
    
    test "complex naive scheduling" do
      @complex_schedule = YAML::load(open("complex_schedule.yml"))

      @complex_naive_results = [{ :task=>"A", :resources=>["Eve"] },
                                { :task=>"B", :resources=>["Bob", "Eve"] },
                                { :task=>"C", :resources=>["Alice", "Bob", "Eve"] },
                                { :task=>"D", :resources=>["Alice", "Eve"] },
                                { :task=>"E", :resources=>["Bob", "Eve"] },
                                { :task=>"F", :resources=>["Bob"] },
                                { :task=>"G", :resources=>["Alice", "Bob"] },
                                { :task=>"H", :resources=>["Alice"] },
                                { :task=>"I", :resources=>["Alice", "Bob", "Eve"] }]

      @populated_rful.schedule = @complex_schedule

      assert_equal @complex_naive_results, @populated_rful.do_scheduling
    end

    test "too many requested resources gives error" do
      rful = Resourceful::Solver.new([{ :task => "NN", :time => 1, :resources => 4 }], @resources)
      assert_raise Resourceful::NotEnoughResourcesError do
        rful.do_scheduling
      end
    end

  end
end

