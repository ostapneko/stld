require_relative 'steps.rb'

class CapybaraTestCase < MiniTest::Spec
  include UserSteps

  describe 'task creation' do
    before do
      DB[:recurring_tasks].delete
      DB[:unique_tasks].delete
      visit_tasks_page
    end

    describe 'context: the user wants to start the task this week' do
      it 'creates a recurring task and enables it' do
        create_recurring_task 'enabled'

        assert page.has_selector?('div.alert-success', text: 'Task created!')
        assert page.has_selector?('div.btn.disabled', text: 'Enabled')
        assert page.has_text? "Recurring task 1 enabled"
      end

      it 'creates a unique task and affects it to the current sprint' do
        create_unique_task 'for current sprint'

        assert page.has_selector?('div.alert-success', text: 'Task created!')
        assert page.has_no_text? "Unique task 1 for current sprint"

        visit_home_page

        assert page.has_text? "Unique task 1 for current sprint"
      end
    end

    describe 'context: the user does not want to start the task this week' do
      it 'creates a recurring task and disables it' do
        create_recurring_task 'disabled'

        assert page.has_button? 'Enable!'
        assert page.has_text? "Recurring task 1 disabled"
      end

      it 'creates a unique task and does not affect it to the current sprint' do
        create_unique_task 'not current sprint'

        assert page.has_selector?('div.alert-success', text: 'Task created!')
        assert page.has_button? 'Affect to sprint'
        assert page.has_text? "Unique task 1 not current sprint"
      end
    end
  end
end
