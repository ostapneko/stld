require_relative '../test_helper'
require_relative '../../services/task_service'

describe TaskService do
  before do
    @recurring_task_service = TaskService.new(RecurringTask)
    @unique_task_service = TaskService.new(UniqueTask)
  end

  describe '#try_create' do
    before do
      DB[:recurring_tasks].delete
      DB[:unique_tasks].delete
    end

    describe 'when the creations params are valid' do
      before do
        params = {
          "description" => "description",
          "frequency"   => 1,
          "status"      => "todo",
          "enabled"     => true,
          "misc_param"  => "foo"
        }
        @errors, @msg = @recurring_task_service.try_create(params)
      end

      it "persists a record in the task database" do
        DB[:recurring_tasks].count.must_equal 1
      end

      it "returns no errors" do
        @errors.must_be_empty
      end

      it "returns a success message" do
        @msg.must_equal "Task created!"
      end

      describe "when the task service is given a UniqueTask" do
        it "creates a UniqueTask" do
          @unique_task_service.try_create({
            "description" => "description",
            "status"      => "todo"
          })

          DB[:unique_tasks].count.must_equal 1
        end
      end
    end

    describe 'when the creations params are invalid' do
      before do
        params = { invalid_params: true }
        @errors, @msg = @recurring_task_service.try_create(params)
      end

      it "doesn't persist the record" do
        DB[:recurring_tasks].count.must_equal 0
      end

      it "returns errors" do
        @errors.wont_be_empty
      end

      it "returns a nil success message" do
        @msg.must_be_nil
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

        @errors, @msg = @unique_task_service.try_delete(id)
      end

      it "deletes the record" do
        DB[:unique_tasks].count.must_equal 0
      end

      it "returns no errors object" do
        @errors.must_be_empty
      end

      it "returns a success message" do
        @msg.must_equal "Task deleted!"
      end
    end

    describe "when the task does not exist" do
      before do
        @errors, @msg = @unique_task_service.try_delete(1)
      end

      it "returns an error with a 'task not found' full_messages'" do
        @errors.must_equal ['The task to delete could not be found']
      end

      it "returns a nil success message" do
        @msg.must_be_nil
      end
    end
  end

  describe '#try_update' do
    before do
      DB[:unique_tasks].delete

      UniqueTask.create({
        description: "desc",
        status:      "todo"
      })

      @params = {
        "id"          => 1,
        "description" => "desc2",
        "misc_params" => "foo"
      }

      @id = UniqueTask.first.id
    end

    describe 'when the task does not exist' do
      before do
        @errors, @msg = @unique_task_service.try_update(@id + 1, @params)
      end

      it "returns an error with a 'task not found' full_messages'" do
        @errors.must_equal ['The task to delete could not be found']
      end

      it "returns a nil success message" do
        @msg.must_be_nil
      end
    end

    describe 'when the new values are valid' do
      before do
        @errors, @msg = @unique_task_service.try_update(@id, @params)
      end

      it "updates the record" do
        UniqueTask[@id].description.must_equal "desc2"
      end

      it "returns no errors object" do
        @errors.must_be_empty
      end

      it "returns a success message" do
        @msg.must_equal "Task updated!"
      end
    end

    describe 'when the new values are invalid' do
      before do
        @errors, @msg = @unique_task_service.try_update(@id, { "description" => nil })
      end

      it "returns errors" do
        @errors.wont_be_empty
      end

      it "returns a nil success message" do
        @msg.must_be_nil
      end
    end
  end
end
