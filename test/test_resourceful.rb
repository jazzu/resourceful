require 'rubygems'
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'resourceful')

class ResourcefulTest < Test::Unit::TestCase
  def setup
    # A sequential schedule of needs
    # Task name:Time required:Resources required
    @schedule = [
                { :task => "A", :time => 3, :resources => 1 },
                { :task => "B", :time => 2, :resources => 2 },
                { :task => "C", :time => 1, :resources => 3 }
               ]

    @resources = [
                 { :name => "X", :time_worked => 0 },
                 { :name => "Y", :time_worked => 0 },
                 { :name => "Z", :time_worked => 0 }
                ]

    @naive_results = [
                      { :task => "A", :resources => ["X"] },
                      { :task => "B", :resources => ["Y", "Z"] },
                      { :task => "C", :resources => ["Y", "Z", "X"] }
                     ]

    @rful = Resourceful.new
    @populated_rful = Resourceful.new(@schedule, @resources)
  end

  def test_must_parse_resource_hash_data
    @rful.resources = @resources
    assert_equal @resources, @rful.resources
  end

  def test_must_parse_schedule_hash_data
    @rful.schedule = @schedule
    assert_equal @schedule, @rful.schedule
  end

  def test_must_parse_schedule_and_resource_hash_data_on_creation
    assert_nothing_raised { rful = Resourceful.new(@schedule, @resources) }
  end

  def test_least_worked_always_returns_first_least_worked_in_list
    assert_equal "X", @populated_rful.least_worked
    @populated_rful.resources[0][:time_worked] = 1
    assert_equal "Y", @populated_rful.least_worked
    @populated_rful.resources[1][:time_worked] = 1
    assert_equal "Z", @populated_rful.least_worked
    @populated_rful.resources[0][:time_worked] = 0
    assert_equal "X", @populated_rful.least_worked
  end

  def test_too_many_requested_resources_gives_error
    ran_out_of_resources = [{ :task => "NN", :resources => [Resourceful::E_NOT_ENOUGH_RESOURCES] }]
    rful = Resourceful.new([{ :task => "NN", :time => 1, :resources => 4 }], @resources)
    assert_equal ran_out_of_resources, rful.do_scheduling
  end

  def test_naive_scheduling
    assert_equal @naive_results, @populated_rful.do_scheduling
  end
end

