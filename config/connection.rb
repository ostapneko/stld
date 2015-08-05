require 'sequel'
require 'yaml'

$stderr.puts "WARNING: The RACK_ENV environment variable is not set. Assuming that the app is run in development mode." unless ENV['RACK_ENV']

env = ENV['RACK_ENV'] || "development"

connection_string = ENV['DATABASE_URL'] || YAML.load(File.read("config/database.yml"))[env]

DB = Sequel.connect(connection_string)
