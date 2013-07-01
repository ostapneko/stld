require_relative '../config/connection'
require_relative '../models/recurring_task'
require_relative '../models/unique_task'

require 'ostruct'

class TaskService
  TASK_CREATED_MSG = "Task created!"
  TASK_UPDATED_MSG = "Task updated!"
  TASK_DELETED_MSG = "Task deleted!"
  TASK_NOT_FOUND_ERR = "The task to delete could not be found"

  def initialize(task_class)
    @task_class = task_class
  end

  def try_create(params)
    task = make(params)
    if task.valid?
      save(task)
    else
      return [task.errors.full_messages, nil]
    end
  end

  def try_delete(id)
    task = @task_class[id]
    if task
      delete(task)
    else
      fail_task_not_found
    end
  end

  def try_update(id, params)
    task = @task_class[id]
    return fail_task_not_found unless task
    updated_keys = (task.keys.map(&:to_s) & params.keys) - ["id"]
    updated_keys.each do |k|
      task.set(k.to_sym => params[k])
    end
    if task.valid?
      update(task)
    else
      return [task.errors.full_messages, nil]
    end
  end

  private

  def make(params)
    creation_params = make_creation_params(params)
    @task_class.new(creation_params)
  end

  def make_creation_params(params)
    common_params = {
      description: params["description"].to_s
    }

    if @task_class == RecurringTask
      add_recurring_params(common_params, params)
    else
      add_unique_params(common_params, params)
    end
  end

  def delete(task)
    task.delete
    [[], TASK_DELETED_MSG]
  end

  def fail_task_not_found
    errors = [TASK_NOT_FOUND_ERR]
    [errors, nil]
  end

  def save(task)
    task.save
    [[], TASK_CREATED_MSG]
  end

  def update(task)
    task.save
    [[], TASK_UPDATED_MSG]
  end

  def add_recurring_params(common_params, params)
    common_params.merge({
      frequency: params["frequency"] && params["frequency"].to_i,
      status:    "todo",
      enabled:   !!params["enabled"]
    })
  end

  def add_unique_params(common_params, params)
    status = params["todo"] ? "todo" : "not_started"
    common_params.merge({
      status: status
    })
  end
end
