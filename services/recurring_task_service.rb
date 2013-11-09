require_relative '../lib/date_helpers'

class RecurringTaskService < TaskService
  include DateHelpers

  def initialize
    @task_class = RecurringTask
  end

  def get_tasks
    RecurringTask.all.map do |t|
      active = t.enabled && t.status == "todo"
      RecurringTaskPresenter.new(t, active).serialize
    end
  end

  def update_recurring_tasks
    get_enabled.each do |t|
      if t.due_this_week? || t.status == 'todo'
        t.status = 'todo'
      else
        t.status = 'skip'
      end
      t.save
    end
  end

  def add_params(common_params, params)
    common_params.merge({
      frequency: params["frequency"] && params["frequency"].to_i,
      status:    "todo",
      enabled:   !!params["enabled"],
      started_at_week: current_week,
      started_at_year: current_year
    })
  end
end
