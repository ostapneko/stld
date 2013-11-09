class UniqueTaskPresenter
  def initialize(task, active)
    @id          = task.id
    @description = task.description
    @active      = active
  end

  def serialize
    {
      id:          @id,
      description: @description,
      active:      @active
    }
  end
end
