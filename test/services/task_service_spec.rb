require_relative '../test_helper'
require_relative '../../services/task_service'

describe TaskService do
  before do
    @service = TaskService.new
  end

  describe '#try_create_recurring_task' do
    before do
      DB[:recurring_tasks].delete
    end

    describe 'when the creations params are valid' do
      before do
        @params = {
          "description" => "description",
          "frequency"   => 1,
          "status"      => "todo",
          "enabled"     => true,
          "misc_param"  => "foo"
        }
      end

      it "persists a record in the task database" do
        @service.try_create_recurring_task(@params)
        DB[:recurring_tasks].count.must_equal 1
      end

      it "returns an empty errors hash" do
       errors = @service.try_create_recurring_task(@params)
       errors.must_be_empty
      end
    end

    describe 'when the creations params are invalid' do
      before do
        @params = { invalid_params: true }
      end

      it "doesn't persist the record" do
        @service.try_create_recurring_task(@params)
        DB[:recurring_tasks].count.must_equal 0
      end

      it "returns a non-empty error hash" do
       errors = @service.try_create_recurring_task(@params)
       errors.wont_be_empty
      end
    end
  end
end
