require 'sinatra'
require 'sinatra/content_for'

require_relative 'models/recurring_task'
require_relative 'models/unique_task'
require_relative 'services/task_service'

get '/' do
  erb :"home/index"
end

get '/tasks' do
  erb :"tasks/index"
end

post '/recurring_task' do
  service = TaskService.new
  @errors, @msg = service.try_create_recurring_task(params)
  erb :"tasks/index"
end
