class UniqueTaskPresenter
  def initialize(task)
    @id          = task.id
    @description = task.description
    @active      = task.status == "todo"
  end

  def serialize
    {
      id:          @id,
      description: @description,
      active:      @active
    }
  end
end
