require_relative '../config/connection.rb'

class RecurringTask < Sequel::Model
  plugin :validation_helpers
  self.raise_on_typecast_failure = false

  def validate
    super
    validates_presence [:description, :frequency, :enabled, :status]
    validates_unique [:description]
    validates_includes %w(todo done skip), :status
  end

  def self.enabled
    where(enabled: true)
  end

  def self.active
    enabled.where(status: ["todo", "done"])
  end
end
