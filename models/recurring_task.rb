require_relative '../config/connection.rb'

class RecurringTask < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:description, :frequency, :enabled, :status]
    validates_unique [:description]
    validates_includes %w(todo done skip), :status
  end

  def self.enabled
    where(enabled: true)
  end
end
