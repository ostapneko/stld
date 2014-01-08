class RecurringTaskPresenter
  def initialize(task)
    @id          = task.id
    @description = task.description
    @active      = task.enabled && task.status == "todo"
    @status      = task.status
    @enabled     = task.enabled
    @frequency   = task.frequency
  end

  def serialize
    {
      id:          @id,
      description: @description,
      active:      @active,
      status:      @status,
      enabled:     @enabled,
      frequency:   @frequency
    }
  end
end
