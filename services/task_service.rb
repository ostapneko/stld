require_relative '../config/connection'
require_relative '../models/recurring_task'
require_relative '../models/unique_task'

class TaskService
  class Result < Struct.new(:status, :body)
  end

  TASK_CREATED_MSG = "Task created!"
  TASK_UPDATED_MSG = "Task updated!"
  TASK_DELETED_MSG = "Task deleted!"
  TASK_NOT_FOUND_ERR = "The task could not be found"
  NOT_PARSABLE_ERR = "Your request could not be parsed"
  TASK_INVALID_ERR = "Task validation failed: %s"

  def initialize
    raise "Abstract class, instantiate child classes instead"
  end

  def self.build(task_class)
    case task_class.to_s
    when "UniqueTask"; UniqueTaskService.new
    when "RecurringTask"; RecurringTaskService.new
    else raise "Cannot build task service for #{task_class}"
    end
  end

  def with_task(task_id, &block)
    task = @task_class[task_id]
    return fail_task_not_found unless task
    yield task
  end

  def with_params(payload, &block)
    params =
      begin
        JSON.parse payload
      rescue
        return fail_non_parsable_payload
      end
    yield params
  end

  def try_create(payload)
    with_params(payload) do |params|
      task = make(params)

      if task.valid?
        create(task)
      else
        fail_task_invalid(task)
      end
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

  def getAll
    @task_class.all
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
    add_params(common_params, params)
  end

  def delete(task)
    task.delete
    ok(TASK_DELETED_MSG)
  end

  def create(task)
    task.save
    ok(TASK_CREATED_MSG)
  end

  def update(task)
    task.save
    ok(TASK_UPDATED_MSG)
  end

  def ok(msg)
    body = {
      "success_message" => msg,
      "status"        => "NOT_FOUND"
    }
    Result.new(200, body)
  end

  def fail_task_not_found
    body = {
      "error_message" => TASK_NOT_FOUND_ERR,
      "status"        => "NOT_FOUND"
    }

    Result.new(404, body)
  end

  def fail_non_parsable_payload
    body = {
      "error_message" => NOT_PARSABLE_ERR,
      "status"        => "UNPARSABLE ENTITY"
    }

    Result.new(400, body)
  end

  def fail_task_invalid(task)
    body = {
      "error_message" => TASK_INVALID_ERR % task.errors.full_messages,
      "status"        => "INVALID REQUEST"
    }

    Result.new(400, body)
  end

end
