class UniqueTaskPresenter
  def initialize(task)
    @id          = task.id
    @description = task.description
    @active      = t.status == "todo"
  end

  def serialize
    {
      id:          @id,
      description: @description,
      active:      @active
    }
  end
end
