require_relative 'task_service'

class UniqueTaskService < TaskService
  def initialize
    @task_class = UniqueTask
  end

  def get_tasks
    UniqueTask.all.map do |t|
      active = t.status == "todo"
      UniqueTaskPresenter.new(t, active).serialize
    end
  end

  def add_params(common_params, params)
    status = params["todo"] ? "todo" : "not_started"
    common_params.merge({
      status: status
    })
  end

  def try_update(task_id, payload)
    with_task(task_id) do |task|
      with_params(payload) do |params|
        task.set(
          description: params["description"],
          status:      params["active"] ? "todo" : "not_started"
        )

        if task.valid?
          update(task)
        else
          TaskPresenter.fail_task_invalid(task)
        end
      end
    end
  end
end
