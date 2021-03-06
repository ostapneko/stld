require_relative '../config/connection.rb'

class UniqueTask < Sequel::Model
  plugin :validation_helpers
  self.raise_on_typecast_failure = false

  def validate
    super
    validates_presence [:description, :status]
    validates_unique [:description]
    validates_includes %w(todo done not_started), :status
  end
end
