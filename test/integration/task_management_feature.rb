require_relative 'steps.rb'

class CapybaraTestCase < MiniTest::Spec
  include UserSteps

  describe 'task management' do
    before do
      DB[:recurring_tasks].delete
      DB[:unique_tasks].delete
      visit_tasks_page
      create_unique_task 'for current sprint'
    end

    it 'can postpone a unique task' do
      visit_home_page
      postpone_unique_task

      visit_home_page
      assert page.has_no_text? 'Unique task 1 for current sprint'
    end

    it 'can mark a unique task as done' do
      visit_home_page
      mark_unique_task_as_done

      assert page.has_text? 'Task updated'

      visit_tasks_page
      assert page.has_text? 'Unique task 1 for current sprint'
    end
  end
end
