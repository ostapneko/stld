require 'sinatra'
require 'sinatra/content_for'

get '/' do
  erb :home
end

get '/tasks' do
  erb :tasks
end
