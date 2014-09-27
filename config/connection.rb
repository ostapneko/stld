require 'sequel'
require 'yaml'
require 'jdbc/postgres'

Jdbc::Postgres.load_driver

unless ENV['JDBC_URL']
  puts "The JDBC_URL env var needs to be set! Aborting..."
  exit 1
end

DB = Sequel.connect(ENV['JDBC_URL'])
