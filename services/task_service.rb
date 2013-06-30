require_relative '../config/connection'
require_relative '../models/recurring_task'

class TaskService
  TASK_CREATED_MSG = "Task created!"

  def try_create_recurring_task(params)
    creation_params = makeCreationParams(params)
    task = RecurringTask.new(creation_params)
    return [task.errors, nil] unless task.valid?
    task.save
    return [{}, TASK_CREATED_MSG]
  end

  private

  def makeCreationParams(params)
    {
      description: params["description"].to_s,
      frequency:   params["frequency"] && params["frequency"].to_i,
      status:      "todo",
      enabled:     !!params["enabled"]
    }
  end
end
