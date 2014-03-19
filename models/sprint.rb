require 'config/connection'
require 'lib/date_helpers'
require 'services/sprint_service'

class Sprint < Sequel::Model
  include DateHelpers

  plugin :validation_helpers
  self.raise_on_typecast_failure = false

  def validate
    super
    validates_unique [:year, :week]
    validates_presence [:year, :week]
    validates_includes (1..53), :week
  end

  def self.current
    if DB[:sprints].empty?
      sprint = SprintService.new.create_new_sprint
      sprint.save
    end
    order(:year, :week).last
  end

  def overdue?
    week_number_string(current_year, current_week) > week_number_string(year, week)
  end

  private

  def week_number_string(year, week)
    "#{year}%02i" % week
  end
end
