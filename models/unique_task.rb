require_relative '../config/connection.rb'

class UniqueTask < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:description, :status]
    validates_unique [:description]
  end
end
