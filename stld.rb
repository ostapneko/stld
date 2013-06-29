require 'sinatra'

get '/'
  erb :home
end

get tasks
  erb :tasks
end
