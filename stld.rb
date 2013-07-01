require 'sinatra'
require 'sinatra/content_for'
require 'rack-flash'

require_relative 'models/recurring_task'
require_relative 'models/unique_task'
require_relative 'services/task_service'

enable :sessions
use Rack::Flash

helpers do
  def create_task(task_class)
    service = TaskService.new(task_class)
    flash[:errors], flash[:notice] = service.try_create(params)
    redirect to('/tasks')
  end

  def delete_task(task_class)
    service = TaskService.new(task_class)
    id = params[:id].to_i
    flash[:errors], flash[:notice] = service.try_delete(id)
    redirect to('/tasks')
  end

  def update_task(task_class)
    service = TaskService.new(task_class)
    id = params[:id].to_i
    flash[:errors], flash[:notice] = service.try_update(id, params)
    redirect to('/tasks')
  end
end

get '/' do
  erb :"home/index"
end

get '/tasks' do
  erb :"tasks/index"
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

put '/recurring_task/:id' do
  update_task(RecurringTask)
end

put '/unique_task/:id' do
  update_task(UniqueTask)
end
