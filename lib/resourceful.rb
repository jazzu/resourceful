module Resourceful

  E_NOT_ENOUGH_RESOURCES = "Not enough resources for task %s (%d required, %d available)"

  class Solver
    attr_accessor :resources, :schedule

    def initialize(schedule=[], resources=[])
      @schedule = schedule
      @resources = resources

      @resources.map do |res|
        res[:time_worked] = 0
        res[:last_worked] = ""
      end
    end

    def least_worked(task="", time=0)
      valid_resources = @resources.find_all{ |res| res[:last_worked] != task }
      res = valid_resources.min { |a,b| a[:time_worked] <=> b[:time_worked] }

      res[:time_worked] += time
      res[:last_worked] = task
      res[:name]
    end

    def do_scheduling
      result_work_schedule = Array.new(@schedule.size, nil)

      # Sort tasks from most hours required to least hours required
      src_schedule = @schedule.sort { |a,b| b[:time] <=> a[:time] }

      src_schedule.each do |task|
        if task[:resources] > @resources.size
          r_error = NotEnoughResourcesError.new(task[:task], task[:resources], @resources.size)
          raise r_error, sprintf(E_NOT_ENOUGH_RESOURCES, task[:task], task[:resources], @resources.size) , caller
        else
          workers = []
          task[:resources].times { workers << least_worked(task[:task], task[:time]) }
          workers.sort!
          result_work_schedule[original_position(task[:task])] = { :task => task[:task], :resources => workers }
        end
      end

      result_work_schedule
    end

    def original_position(task)
      @schedule.each_index do |i|
        return i if @schedule[i][:task] == task
      end
    end

  end

  class NotEnoughResourcesError < StandardError
    attr_reader :task, :resources_required, :resources_available

    def initialize(failed_task, resources_required, resources_available)
      @task = failed_task
      @resources_required = resources_required
      @resources_available = resources_available
    end
  end

end
