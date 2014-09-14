require 'sequel'
require 'yaml'
require 'jdbc/postgres'

Jdbc::Postgres.load_driver

$stderr.puts "WARNING: The RACK_ENV environment variable is not set. Assuming that the app is run in development mode." unless ENV['RACK_ENV']

env = ENV['RACK_ENV'] || "development"

config = YAML.load(File.read("config/database.yml"))[env]

jdbc_url = "jdbc:postgresql://#{config['host']}/#{config['database']}?user=#{config['username']}&password=#{config['password']}"

DB = Sequel.connect(jdbc_url)
