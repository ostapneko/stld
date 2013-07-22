require_relative '../../test_helper'
require_relative '../../../models/recurring_task'

describe RecurringTask do

  before do
    DB[:recurring_tasks].delete
    @task1 = RecurringTask.new(description: 'description', enabled: true, status: 'todo', started_at_week: 20, started_at_year: 2013, frequency: 2)
    @task2 = RecurringTask.new(description: 'description2', enabled: true, status: 'todo', started_at_week: 52, started_at_year: 2013, frequency: 2)
  end

  describe '#due_for_week?' do
    it 'checks if a task is due on a particular week' do
      @task1.due_for_week?(2013, 22).must_equal true
      @task1.due_for_week?(2013, 40).must_equal true
      @task1.due_for_week?(2013, 23).must_equal false
    end

    it 'handles new years correctly' do
      @task2.due_for_week?(2014, 1).must_equal false
      @task2.due_for_week?(2014, 2).must_equal true
    end
  end
end
