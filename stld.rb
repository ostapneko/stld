require 'sinatra'
require 'sinatra/content_for'
require 'rack-flash'
require 'json'

require_relative 'models/recurring_task'
require_relative 'models/unique_task'
require_relative 'models/sprint'

require_relative 'services/task_service'
require_relative 'services/unique_task_service'
require_relative 'services/recurring_task_service'

require_relative 'presenters/unique_task_presenter'
require_relative 'presenters/recurring_task_presenter'


enable :sessions
use Rack::Flash
include ERB::Util

helpers do
  def create_task(task_class)
    service = TaskService.build(task_class)
    flash[:errors], flash[:notice] = service.try_create(params)
    redirect to('/tasks')
  end

  def delete_task(task_class)
    service = TaskService.build(task_class)
    id = params[:id].to_i
    errors, notice = service.try_delete(id)
    if request.xhr?
      content_type :json
      {id: id, errors: errors, notice: notice }.to_json
    else
      flash[:errors], flash[:notice] = errors, notice
      redirect to('tasks')
    end
  end

  def update_task(task_class)
    service = TaskService.build(task_class)
    id      = params[:id].to_i
    payload = request.body.read
    result  = service.try_update(id, payload)

    content_type :json
    status       result.status
    body         result.body.to_json
  end
end

get '/tasks' do
  uniq_tasks = UniqueTaskService.new.get_tasks
  rec_tasks  = RecurringTaskService.new.get_tasks

  content_type :json
  {
    "uniqueTasks"    => uniq_tasks,
    "recurringTasks" => rec_tasks
  }.to_json
end

post '/recurring_task' do
  create_task(RecurringTask)
end

post '/unique_task' do
  create_task(UniqueTask)
end

delete '/recurring_task/:id' do
  delete_task(RecurringTask)
end

delete '/unique_task/:id' do
  delete_task(UniqueTask)
end

put '/recurring-task/:id' do
  update_task(RecurringTask)
end

put '/unique-task/:id' do
  update_task(UniqueTask)
end

post '/start_new_sprint' do
  flash[:errors], flash[:notice] = SprintService.new.start_new_sprint
  redirect to('/')
end
