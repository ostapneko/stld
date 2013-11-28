class RecurringTaskPresenter
  def initialize(task)
    @id          = task.id
    @description = task.description
    @active      = task.enabled && task.status == "todo"
    @enabled     = task.enabled
  end

  def serialize
    {
      id:          @id,
      description: @description,
      active:      @active,
      enabled:     @enabled
    }
  end
end
