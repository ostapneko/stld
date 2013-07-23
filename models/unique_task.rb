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

  def self.active
    where(status: "todo")
  end

  def self.done
    where(status: "done")
  end

  def done
    status == 'done'
  end

  def self.shown_in_task_list
    where(status: "not_started").order(:id)
  end
end
