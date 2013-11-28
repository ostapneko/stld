require_relative '../config/connection'
require_relative '../models/recurring_task'
require_relative '../models/unique_task'
require_relative '../presenters/task_presenter'

class TaskService
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
    return TaskPresenter.fail_task_not_found unless task
    yield task
  end

  def with_params(payload, &block)
    params =
      begin
        JSON.parse payload
      rescue
        return TaskPresenter.fail_non_parsable_payload
      end
    yield params
  end

  def try_create(payload)
    with_params(payload) do |params|
      task = make(params)

      if task.valid?
        create(task)
      else
        TaskPresenter.fail_task_invalid(task)
      end
    end
  end

  def try_delete(task_id)
    with_task(task_id) do |task|
      delete(task)
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
    add_params(common_params, params)
  end

  def delete(task)
    task.delete
    TaskPresenter.ok('Task deleted!')
  end

  def create(task)
    task.save
    presenter = TaskPresenter.build_from_task(task)
    TaskPresenter.task_created(presenter)
  end

  def update(task)
    task.save
    TaskPresenter.ok('Task updated!')
  end
end
