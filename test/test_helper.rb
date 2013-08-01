ENV["RACK_ENV"] ||= "test"
require 'minitest/autorun'
require 'capybara'
require 'capybara/poltergeist'
require_relative '../lib/date_helpers'
require_relative '../stld.rb'

Capybara.app = Sinatra::Application
Capybara.current_driver = :poltergeist
