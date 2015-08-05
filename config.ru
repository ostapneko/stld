require './stld.rb'

['USERNAME', 'PASSWORD', 'SECRET_KEY'].each do |k|
  raise "Set the #{k} env var" unless ENV[k]
end

app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
    {
      ENV['USERNAME'] => ENV['PASSWORD']
    }[username]
end

app.realm = 'Protected Area'
app.opaque = ENV['SECRET_KEY']

run app
