require_relative '../config/connection'
require_relative '../models/recurring_task'

class TaskService
  def try_create_recurring_task(params)
    creation_params = makeCreationParams(params)
    task = RecurringTask.new(creation_params)
    return task.errors unless task.valid?
    task.save
    return {}
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
