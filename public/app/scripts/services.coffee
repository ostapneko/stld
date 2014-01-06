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

class Alert
  constructor: (@message) ->

angular.module('stldApp.services', [])
  .factory('taskService', ['$http', ($http) ->
    service = {}

    service.getAllTasks = (uniqueTasks, recurringTasks) ->
      $http.get('/tasks')
        .success( (body, status, headers, config) ->
          uniqueTasks.push(new UniqueTask(
            t.id,
            t.description,
            t.active,
            'show',
            t.description
          )) for t in body["uniqueTasks"]
          recurringTasks.push(new RecurringTask(
            t.id,
            t.description,
            t.active,
            t.frequency,
            'show',
            t.status
          )) for t in body["recurringTasks"]
        )
        .error( (body, status, headers, config) ->
          console.log(body, status)
        )

    service.askForCreate = (type, payload, tasks, alerts) ->
      $http.post("/#{type}-task", payload)
        .success( (body, status, headers, config) ->
          task = body.task
          newTask = service.createTask(type, task)
          tasks.push(newTask)
        )
        .error( (body, status, headers, config) ->
          alert = new Alert(body['error_message'])
          alerts.length = 0
          alerts.push(alert)
        )

    service.askForUpdate = (type, task, payload, alerts) ->
      $http.put("/#{type}-task/#{task.id}", payload)
        .success( (body, status, headers, config) -> task.update(payload) )
        .error( (body, status, headers, config) ->
          alert = new Alert(body['error_message'])
          alerts.length = 0
          alerts.push(alert)
        )

    service.askForDelete = (type, task, tasks) ->
      $http.delete("/#{type}-task/#{task.id}")
        .success( (body, status, headers, config) ->
          i = tasks.indexOf(task)
          tasks.splice(i, 1)
        )
        .error( (body, status, headers, config) -> console.log(body, status) )

    service.askForNewSprint = (alerts) ->
      $http.post("/start-new-sprint")
        .success( (body, status, headers, config) -> service.getAllTasks([], []))
        .error( (body, status, headers, config) ->
          alert = new Alert(body['error_message'])
          alerts.length = 0
          alerts.push(alert)
        )
    service.createTask = (type, task) ->
      if type == 'unique'
        new UniqueTask( task.id, task.description,
                        task.active, 'show', task.description )
      else
        new RecurringTask( task.id, task.description,
                           task.active, task.frequency,
                           'show', task.status )
    service
  ])
