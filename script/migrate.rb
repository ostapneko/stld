#!/usr/bin/env ruby
require 'yaml'

class Migrator
  def initialize(args)
    @destroy = args[0] == "destroy"
  end

  def run
    env = ENV['RACK_ENV'] || "development"
    config = YAML.load(File.read("config/database.yml"))[env]
    connection_string = "postgres://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}"
    options = "-m migrations"
    options << " -M 0" if @destroy
    `sequel #{options} #{connection_string}`
  end
end

if $0 == __FILE__
  Migrator.new(ARGV).run
end
