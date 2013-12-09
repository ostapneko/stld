require_relative '../config/connection'
require_relative '../models/sprint'

class SprintService
  include DateHelpers

  SPRINT_CREATED_MSG      = "New sprint started!"
  SPRINT_NOT_FINISHED_MSG = "You can't create a new sprint before the week is over"

  def start_new_sprint
    return(sprint_not_finished_response) if current_sprint_not_finished?

    sprint = create_new_sprint

    if sprint.valid?
      save(sprint)
      success_response
    else
      sprint_invalid_response
    end
  end

  def create_new_sprint
    Sprint.new(year: current_year, week: current_week)
  end

  private

  def sprint_not_finished_response
    body = {
      "error_message" => SPRINT_NOT_FINISHED_MSG,
      "status"        => "INVALID REQUEST"
    }
    Response.new(400, body)
  end

  def current_sprint_not_finished?
    Sprint.current && !Sprint.current.overdue?
  end

  def success_response
    body = {
      "status" => "CREATED",
      "success_message" => SPRINT_CREATED_MSG
    }
    Response.new(201, body)
  end

  def sprint_invalid_response
    body = {
      "status"        => "SERVER ERROR",
      "error_message" => sprint.errors.full_messages
    }
    Response.new(500, body)
  end

  def save(sprint)
    DB.transaction do
      sprint.save
      RecurringTaskService.new.update_recurring_tasks
    end
  end
end
