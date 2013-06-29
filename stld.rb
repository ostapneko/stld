require 'sinatra'

get '/' do
  erb :home
end

get '/tasks' do
  erb :tasks
end
