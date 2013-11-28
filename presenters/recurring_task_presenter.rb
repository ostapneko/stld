class RecurringTaskPresenter
  def initialize(task, active)
    @id          = task.id
    @description = task.description
    @active      = active
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
