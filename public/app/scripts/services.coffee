class Task
  cancelEdit: ->
    @mode = 'show'
    @tempDescription = @description

  addEditMode: ->
    @mode = 'edit'

class UniqueTask extends Task
  constructor: (@id, @description, @active, @mode, @tempDescription) ->

  displayAction: ->
    if @active then "Postpone" else "To Sprint"

  update: (params) ->
    @description     = params.description
    @active          = params.active
    @tempDescription = params.description
    @mode            = 'show'

class RecurringTask extends Task
  constructor: (@id, @description, @active, @frequency, @mode, @status, @tempDescription, @tempFrequency) ->

  update: (params) ->
    @description     = params.description
    @frequency       = params.frequency
    @mode            = "show"
    @tempDescription = params.description
    @tempFrequency   = params.frequency
    @status          = params.status
    @active          = params.active || @status == "todo"

angular.module('stldApp.services', [])
  .factory('taskService', ['$http', '$q', ($http, $q) ->
    service = {}

    service.getTasks = ->
      $http.get('/tasks')
        .then(
          (response) ->
            uniqueTasks =
              (new UniqueTask(t.id, t.description, t.active,
                              'show', t.description) for t in response.data.uniqueTasks)
            recurringTasks =
              (new RecurringTask( t.id, t.description, t.active,
                                  t.frequency, 'show', t.status,
                                  t.description, t.frequency) for t in response.data.recurringTasks)

            { unique: uniqueTasks, recurring: recurringTasks }
          ,
          (response) -> $q.reject(response.data.error_message)
        )

    service.createUnique = (payload) ->
      $http.post("/unique-task", payload)
        .then(
          (response) ->
            t = response.data.task
            new UniqueTask( t.id, t.description, t.active,
                            'show', t.description )
          ,
          (response) -> $q.reject(response.data.error_message)
        )

    service.createRecurring = (payload) ->
      $http.post("/recurring-task", payload)
        .then(
          (response) ->
            t = response.data.task
            new RecurringTask( t.id, t.description, t.active,
                               t.frequency, 'show', t.status,
                               t.description, t.frequency )
          ,
          (response) -> $q.reject(response.data.error_message)
        )

    service.update = (type, task, payload) ->
      $http.put("/#{type}-task/#{task.id}", payload)
        .then(
          (response) -> task.update(payload),
          (response) -> $q.reject(response.data.error_message)
        )

    service.delete = (type, task) ->
      $http.delete("/#{type}-task/#{task.id}")
        .then(
          (response) -> task,
          (response) -> $q.reject(response.data.error_message)
        )

    service.newSprintAllowed = ->
      $http.get("/new_sprint_allowed")

    service.startNewSprint = ->
      $http.post("/start-new-sprint")
        .then(
          (response) ->
            service.newSprintAllowed()
            service.getTasks()
          ,
          (response) -> $q.reject(response.data.error_message)
        )

    service
  ])
