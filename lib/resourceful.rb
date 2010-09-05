require 'rubygems'
require 'pp'

class Resourceful

  E_NOT_ENOUGH_RESOURCES = "Not enough resources"

  attr_accessor :resources, :schedule

  def initialize(schedule=[], resources=[])
    @schedule = schedule
    @resources = resources
  end

  def least_worked(time=0)
    res = @resources.min { |a,b| a[:time_worked] <=> b[:time_worked] }
    res[:time_worked] += time
    res[:name]
  end

  def do_scheduling
    result_work_schedule = []
    @schedule.each do |task|
      if task[:resources] > @resources.length
        result_work_schedule << { :task => task[:task], :resources => [E_NOT_ENOUGH_RESOURCES] }
        next
      else
        workers = []
        task[:resources].times { workers << least_worked(task[:time]) }
        result_work_schedule << { :task => task[:task], :resources => workers }
      end
    end
    result_work_schedule
  end

end
