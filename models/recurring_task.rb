require_relative '../config/connection.rb'
require_relative '../lib/date_helpers'

class RecurringTask < Sequel::Model
  include DateHelpers

  plugin :validation_helpers
  self.raise_on_typecast_failure = false

  def validate
    super
    validates_presence [:description, :frequency, :enabled, :status, :started_at_week, :started_at_year]
    validates_unique [:description]
    validates_includes %w(todo done skip), :status
    validates_includes (1..6), :frequency
  end

  def due_this_week?
    due_for_week?(current_year, current_week)
  end

  def due_for_week?(year, week)
    diff = number_of_weeks(year, week) - number_of_weeks(started_at_year, started_at_week)
    diff % frequency == 0
  end
end
