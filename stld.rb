require 'sinatra'
require 'sinatra/content_for'
require 'rack-flash'
require 'json'

require 'ostruct'

$LOAD_PATH << File.dirname(__FILE__)

require 'config/connection'

require 'models/recurring_task'
require 'models/unique_task'
require 'models/sprint'

require 'services/task_service'
require 'services/unique_task_service'
require 'services/recurring_task_service'

require 'presenters/unique_task_presenter'
require 'presenters/recurring_task_presenter'


enable :sessions
raise 'set the SESSION_SECRET env var' unless ENV['SESSION_SECRET']
set :session_secret, ENV['SESSION_SECRET']
use Rack::Flash
include ERB::Util

helpers do
  def respond(result)
    content_type :json
    status       result.status
    body         result.body.to_json
  end

  def create_task(task_class)
    service = TaskService.build(task_class)
    payload = request.body.read
    result = service.try_create(payload)

    respond result
  end

  def delete_task(task_class)
    service = TaskService.build(task_class)
    id = params[:id].to_i
    result = service.try_delete(id)

    respond result
  end

  def update_task(task_class)
    service = TaskService.build(task_class)
    id      = params[:id].to_i
    payload = request.body.read
    result  = service.try_update(id, payload)

    respond result
  end
end

get '/tasks' do
  response = TaskService.new.task_list_response
  respond response
end

post '/recurring-task' do
  create_task(RecurringTask)
end

post '/unique-task' do
  create_task(UniqueTask)
end

delete '/recurring-task/:id' do
  delete_task(RecurringTask)
end

delete '/unique-task/:id' do
  delete_task(UniqueTask)
end

put '/recurring-task/:id' do
  update_task(RecurringTask)
end

put '/unique-task/:id' do
  update_task(UniqueTask)
end

get '/new_sprint_allowed' do
  response = SprintService.new.new_sprint_allowed?
  respond response
end

post '/start-new-sprint' do
  response = SprintService.new.start_new_sprint
  respond response
end

if ENV['RACK_ENV'] == 'test'
  delete '/truncate_db' do
    [:recurring_tasks, :unique_tasks, :sprints].each { |db| DB[db].delete }
    redirect to('/index.html')
  end
end
