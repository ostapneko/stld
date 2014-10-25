require 'sequel'
require 'yaml'

$stderr.puts "WARNING: The RACK_ENV environment variable is not set. Assuming that the app is run in development mode." unless ENV['RACK_ENV']

env = ENV['RACK_ENV'] || "development"

config = YAML.load(File.read("config/database.yml"))[env]

DB = Sequel.connect("postgres://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}")
