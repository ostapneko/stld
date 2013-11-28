require_relative '../test_helper'
require_relative '../../lib/date_helpers'
require_relative '../../services/task_service'
require_relative '../../services/unique_task_service'

describe UniqueTaskService do
  before do
    @unique_task_service = TaskService.build(UniqueTask)
  end

  describe '#try_update' do
    before do
      DB[:unique_tasks].delete

      UniqueTask.create({
        description: "desc",
        status:      "todo"
      })

      @id = UniqueTask.first.id

      @params = {
        "id"          => 1,
        "description" => "desc2",
        "misc_params" => "foo"
      }.to_json

      @nil_params = {
        "description" => nil
      }.to_json

    end

    describe 'when the task does not exist' do
      before do
        @result = @unique_task_service.try_update(@id + 1, @params)
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

    describe 'when the new values are valid' do
      before do
        @result = @unique_task_service.try_update(@id, @params)
        @status = @result.status
        @body = @result.body
      end

      it "updates the record" do
        UniqueTask[@id].description.must_equal "desc2"
      end

      it "returns no errors object" do
        @body["error_message"].must_be_nil
      end

      it "returns a success message" do
        @body["success_message"].must_equal "Task updated!"
      end
    end

    describe 'when the new values are invalid' do
      before do
        @result = @unique_task_service.try_update(@id, @nil_params)
        @status = @result.status
        @body = @result.body
      end

      it "returns errors" do
        @body["error_message"].wont_be_empty
      end

      it "returns a nil success message" do
        @body["success_message"].must_be_nil
      end
    end
  end
end

