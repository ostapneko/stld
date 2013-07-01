require_relative '../config/connection'
require_relative '../models/recurring_task'
require_relative '../models/unique_task'

require 'ostruct'

class TaskService
  TASK_CREATED_MSG = "Task created!"
  TASK_DELETED_MSG = "Task deleted!"
  TASK_NOT_FOUND_ERR = "The task to delete could not be found"

  def initialize(task_class)
    @task_class = task_class
  end

  def try_create_task(params)
    task = make_task(params)

    if task.valid?
      save_task(task)
    else
      return [task.errors.full_messages, nil]
    end
  end

  def try_delete_task(id)
    task = @task_class[id]
    if task
      delete_task(task)
    else
      fail_task_not_found
    end
  end

  private

  def make_task(params)
    creation_params = make_creation_params(params)
    @task_class.new(creation_params)
  end

  def make_creation_params(params)
    common_params = {
      description: params["description"].to_s,
      status:      "todo",
    }

    if @task_class == RecurringTask
      add_recurring_params(common_params, params)
    else
      common_params
    end
  end

  def delete_task(task)
    task.delete
    [[], TASK_DELETED_MSG]
  end

  def fail_task_not_found
    errors = [TASK_NOT_FOUND_ERR]
    [errors, nil]
  end

  def save_task(task)
    task.save
    [[], TASK_CREATED_MSG]
  end

  def add_recurring_params(common_params, params)
    common_params.merge({
      frequency: params["frequency"] && params["frequency"].to_i,
      enabled:   !!params["enabled"]
    })
  end
end
