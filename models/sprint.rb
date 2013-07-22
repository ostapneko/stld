require_relative '../config/connection'
require_relative '../lib/date_helpers'
require_relative '../services/sprint_service'

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
    current_number = current_year.to_s + current_week.to_s
    sprint_number = year.to_s + week.to_s
    current_number > sprint_number
  end
end
