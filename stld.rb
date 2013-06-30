require 'sinatra'
require 'sinatra/content_for'
require 'rack-flash'

require_relative 'models/recurring_task'
require_relative 'models/unique_task'
require_relative 'services/task_service'

enable :sessions
use Rack::Flash

helpers do
  def delete_task(task_class)
    service = TaskService.new
    id = params[:id].to_i
    flash[:errors], flash[:notice] = service.try_delete_task(params[:id], RecurringTask)
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
  service = TaskService.new
  flash[:errors], flash[:notice] = service.try_create_recurring_task(params)
    redirect to('/tasks')
end

delete '/recurring_task/:id' do
  delete_task(RecurringTask)
end

delete '/unique_task/:id' do
  delete_task(UniqueTask)
end
