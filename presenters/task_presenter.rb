class TaskPresenter
  TASK_NOT_FOUND_ERR = "The task could not be found"
  NOT_PARSABLE_ERR   = "Your request could not be parsed"
  TASK_INVALID_ERR   = "Task validation failed: %s"

  TASK_CREATED_MSG   = "Task created"

  class Result < Struct.new(:status, :body)
  end


  class << self
    def build_from_task(task)
      presenter_class =
        case task
        when UniqueTask; UniqueTaskPresenter
        when RecurringTask; RecurringTaskPresenter
        else raise "Cannot build task presenter for #{task_class}"
        end
      presenter_class.new(task)
    end

    def ok(msg)
      body = {
        "success_message" => msg,
        "status"          => "OK",
      }
      Result.new(200, body)
    end

    def task_created(presenter)
      body = {
        "success_message" => TASK_CREATED_MSG,
        "status"          => "CREATED",
        "task"            => presenter.serialize
      }
      Result.new(201, body)
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
end
