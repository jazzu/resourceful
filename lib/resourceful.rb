require 'rubygems'
require 'pp'

class Resourceful

  E_NOT_ENOUGH_RESOURCES = "Not enough resources"

  attr_accessor :resources, :schedule

  def initialize(schedule=[], resources=[])
    @schedule = schedule
    @resources = resources
  end

  def least_worked(task="", time=0)
    valid_resources = @resources.find_all{ |res| res[:last_worked] != task }
    res = valid_resources.min { |a,b| a[:time_worked] <=> b[:time_worked] }
    res[:time_worked] += time
    res[:last_worked] = task
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
        task[:resources].times { workers << least_worked(task[:task], task[:time]) }
        result_work_schedule << { :task => task[:task], :resources => workers }
      end
    end
    result_work_schedule
  end

end
