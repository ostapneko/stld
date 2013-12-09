require_relative '../test_helper'
require_relative '../../services/sprint_service'

describe SprintService do
  before do
    DB[:sprints].delete
    DB[:recurring_tasks].delete
    @current_year = DateHelpers.current_year
    @current_week = DateHelpers.current_week
  end

  describe 'when the last sprint is overdue' do
    before do
      # Create an overdue sprint
      Sprint.create(year: @current_year, week: (@current_week - 1))
      # Task long overdue
      @task1 = RecurringTask.create(description: 'description', enabled: true, status: 'todo', started_at_week: (@current_week - 3), started_at_year: @current_year, frequency: 2)
      # Task due this week
      @task2 = RecurringTask.create(description: 'description2', enabled: true, status: 'done', started_at_week: (@current_week - 2), started_at_year: @current_year, frequency: 2)
      # Task not due this week
      @task3 = RecurringTask.create(description: 'description3', enabled: true, status: 'done', started_at_week: (@current_week - 1), started_at_year: @current_year, frequency: 4)
    end

    it 'creates a new sprint' do
      SprintService.new.start_new_sprint
      Sprint.current.week.must_equal @current_week
    end

    it 'updates the recurring tasks' do
      SprintService.new.start_new_sprint
      RecurringTask.find(description: "description").status.must_equal 'todo'
      RecurringTask.find(description: "description2").status.must_equal 'todo'
      RecurringTask.find(description: "description3").status.must_equal 'skip'
    end

    it 'returns a notification message and no error' do
      response = SprintService.new.start_new_sprint
      response.status.must_equal 201
      response.body["success_message"].must_equal SprintService::SPRINT_CREATED_MSG
    end
  end

  describe 'when the last sprint is not overdue' do
    it 'returns an error message' do
      Sprint.create(year: @current_year, week: @current_week)
      response = SprintService.new.start_new_sprint
      response.status.must_equal 400
      response.body["error_message"].must_equal SprintService::SPRINT_NOT_FINISHED_MSG
    end
  end
end
