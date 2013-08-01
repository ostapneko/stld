require_relative 'steps.rb'

class CapybaraTestCase < MiniTest::Spec
  include UserSteps

  describe 'task deletion' do
    before do
      DB[:recurring_tasks].delete
      DB[:unique_tasks].delete
      visit_tasks_page
    end

    it 'removes a task from the tasks page and home page' do
      create_recurring_task 'enabled'
      delete_recurring_task

      assert page.has_selector?('div.alert-success', text: 'Task deleted!')
      assert page.has_no_text? 'Recurring task 1 enabled'

      visit_home_page

      assert page.has_no_text? 'Recurring task 1 enabled'
    end
  end
end
