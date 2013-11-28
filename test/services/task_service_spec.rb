require_relative '../test_helper'
require_relative '../../lib/date_helpers'
require_relative '../../services/task_service'
require_relative '../../services/unique_task_service'
require_relative '../../services/recurring_task_service'

describe TaskService do
  before do
    @recurring_task_service = TaskService.build(RecurringTask)
    @unique_task_service = TaskService.build(UniqueTask)
  end

  describe '#try_create' do
    before do
      DB[:recurring_tasks].delete
      DB[:unique_tasks].delete

      @params = {
          "description" => "description",
          "frequency"   => 1,
          "status"      => "todo",
          "enabled"     => true,
          "misc_param"  => "foo"
        }.to_json

      @invalid_params = { invalid_params: true }.to_json
    end

    describe 'when the creation params are valid' do
      before do
        @result = @recurring_task_service.try_create(@params)
        @status = @result.status
        @body = @result.body
      end

      it "persists a record in the task database" do
        DB[:recurring_tasks].count.must_equal 1
      end

      it "returns no errors" do
        @body["error_message"].must_be_nil
      end

      it "returns a success message" do
        @body["success_message"].must_equal "Task created!"
      end

      it "remembers the week and year the task was started" do
        DB[:recurring_tasks].first[:started_at_week].must_equal(DateHelpers.current_week)
        DB[:recurring_tasks].first[:started_at_year].must_equal(DateHelpers.current_year)
      end

      describe "when the task service is given a UniqueTask" do
        it "creates a UniqueTask" do
          @unique_task_service.try_create({
            "description" => "description",
            "status"      => "todo"
          }.to_json)

          DB[:unique_tasks].count.must_equal 1
        end
      end
    end

    describe 'when the creations params are invalid' do
      before do
        @result = @recurring_task_service.try_create(@invalid_params)
        @status = @result.status
        @body = @result.body
      end

      it "doesn't persist the record" do
        DB[:recurring_tasks].count.must_equal 0
      end

      it "returns errors" do
        @body["error_message"].wont_be_empty
      end

      it "returns a nil success message" do
        @body["success_message"].must_be_nil
      end
    end
  end

  describe '#try_delete' do
    before do
      DB[:unique_tasks].delete
    end

    describe "when the task exists" do
      before do
        UniqueTask.create({
          description: "desc",
          status:      "todo"
        })

        id = UniqueTask.first.id

        @result = @unique_task_service.try_delete(id)
        @status = @result.status
        @body = @result.body
      end

      it "deletes the record" do
        DB[:unique_tasks].count.must_equal 0
      end

      it "returns no errors object" do
        @status.must_equal(200)
      end

      it "returns a success message" do
        @body["success_message"].must_equal "Task deleted!"
      end
    end

    describe "when the task does not exist" do
      before do
        @result = @unique_task_service.try_delete(1)
        @status = @result.status
        @body = @result.body
      end

      it "returns an error with a 'task not found' full_messages'" do
        @body["error_message"].must_equal 'The task could not be found'
      end

      it "returns a nil success message" do
        @body["success_message"].must_be_nil
      end
    end
  end
end
