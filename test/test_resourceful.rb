# -*- coding: utf-8 -*-
require 'rubygems'
require 'yaml'
require 'contest'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'resourceful')

class ResourcefulTest < Test::Unit::TestCase

  setup do
    @schedule = [{ :task_name => "Restroom cleaning", :time => 1, :resources_required => 2 },
                 { :task_name => "Flyer distribution", :time => 2, :resources_required => 3 },
                 { :task_name => "Tour of the venue", :time => 3, :resources_required => 1 }]

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
      @naive_results = [{ :task_name => "Restroom cleaning", :resources_allocated => ["Bob", "Eve"] },
                        { :task_name => "Flyer distribution", :resources_allocated => ["Alice", "Bob", "Eve"] },
                        { :task_name => "Tour of the venue", :resources_allocated => ["Alice"] }]
      assert_equal @naive_results, @populated_rful.do_scheduling
    end
    
    test "complex naive scheduling" do
      @complex_schedule = YAML::load(open( File.join(File.dirname(File.expand_path(__FILE__)), "complex_schedule.yml")))

      @complex_naive_results = [{ :task_name=>"A", :resources_allocated=>["Eve"] },
                                { :task_name=>"B", :resources_allocated=>["Bob", "Eve"] },
                                { :task_name=>"C", :resources_allocated=>["Alice", "Bob", "Eve"] },
                                { :task_name=>"D", :resources_allocated=>["Alice", "Eve"] },
                                { :task_name=>"E", :resources_allocated=>["Bob", "Eve"] },
                                { :task_name=>"F", :resources_allocated=>["Bob"] },
                                { :task_name=>"G", :resources_allocated=>["Alice", "Bob"] },
                                { :task_name=>"H", :resources_allocated=>["Alice"] },
                                { :task_name=>"I", :resources_allocated=>["Alice", "Bob", "Eve"] }]

      @populated_rful.schedule = @complex_schedule
      assert_equal @complex_naive_results, @populated_rful.do_scheduling
    end

    test "too many requested resources gives error" do
      rful = Resourceful::Solver.new([{ :task_name => "NN", :time => 1, :resources_required => 4 }], @resources)
      assert_raise Resourceful::NotEnoughResourcesError do
        rful.do_scheduling
      end
    end

  end
end

