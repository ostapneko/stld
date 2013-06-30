require 'sinatra'
require 'sinatra/content_for'

require_relative 'models/recurring_task'
require_relative 'models/unique_task'

get '/' do
  erb :home
end

get '/tasks' do
  erb :tasks
end
