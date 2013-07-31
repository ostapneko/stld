ENV["RACK_ENV"] ||= "test"
require 'minitest/autorun'
require 'capybara'
require_relative '../lib/date_helpers'
require_relative '../stld.rb'

Capybara.app = Sinatra::Application
Capybara.current_driver = Capybara.javascript_driver # :selenium by default
