require_relative '../test_helper'

module UserSteps
  include Capybara::DSL

  def visit_tasks_page
    visit '/tasks'
  end

  def visit_home_page
    visit '/'
  end

  def create_recurring_task status
    click_button 'show-recurring-task-form-creation'
    within 'form#recurring-task-form-creation' do
      fill_in 'Description', with: "Recurring task 1 #{status}"
      uncheck 'Enable' if status == 'disabled'
      click_button 'OK'
    end
  end

  def create_unique_task status
    click_button 'show-unique-task-form-creation'
    within 'form#unique-task-form-creation' do
      fill_in 'Description', with: "Unique task 1 #{status}"
      check 'Affect to this sprint' if status == 'for current sprint'
      click_button 'OK'
    end
  end

  def delete_recurring_task
    click_button 'Delete'
  end

  def postpone_unique_task
    click_button 'Postpone'
  end

  def mark_unique_task_as_done
    click_button 'Done'
  end
end
