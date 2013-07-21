require_relative '../config/connection'
require_relative '../models/sprint'

class SprintService
  include DateHelpers

  SPRINT_CREATED_MSG      = "New sprint started!"
  SPRINT_NOT_FINISHED_MSG = "You can't create a new sprint before the week is over"

  def start_new_sprint
    return [[SPRINT_NOT_FINISHED_MSG], nil] if current_sprint_not_finished?
    sprint = create_new_sprint
    if sprint.valid?
      save(sprint)
    else
      [sprint.errors.full_messages, nil]
    end
  end

  def create_new_sprint
    Sprint.new(year: current_year, week: current_week)
  end

  private

  def current_sprint_not_finished?
    Sprint.current && !Sprint.current.overdue?
  end

  def save(sprint)
    sprint.save
    update_recurring_tasks
    [[], SPRINT_CREATED_MSG]
  end

  def update_recurring_tasks
    RecurringTask.enabled.each do |t|
      if t.due_this_week? || t.status == 'todo'
        t.status = 'todo'
      else
        t.status = 'skip'
      end
      t.save
    end
  end
end
