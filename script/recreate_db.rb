require 'yaml'
env = ENV['RACK_ENV'] || "development"
config = YAML.load(File.read("config/database.yml"))[env]
connection_string = "postgres://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}"
`sequel -M 0 -m migrations #{connection_string}`
`sequel -m migrations #{connection_string}`
