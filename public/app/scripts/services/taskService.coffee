taskServiceModule = angular.module('taskServiceModule', [])

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
    constructor: (@id, @description, @active, @enabled, @frequency, @mode, @tempDescription) ->

    displayAction: ->
      if @enabled then "Disable" else "Enable"

class Alert
    constructor: (@message) ->

taskServiceModule
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
                        t.enabled,
                        t.frequency,
                        'show',
                        t.description
                    )) for t in body["recurringTasks"]
                )
                .error( (body, status, headers, config) ->
                    console.log(body, status)
                )

        service.createUniqueTask =
            (payload, uniqueTasks, alerts) ->
                $http.post("/unique-task", payload)
                    .success( (body, status, headers, config) ->
                        task = body.task
                        newTask = new UniqueTask(
                            task.id, task.description, task.active, 'show', task.description)
                        uniqueTasks.push(newTask)
                    )
                    .error( (body, status, headers, config) ->
                        alert = new Alert(body['error_message'])
                        alerts.push(alert)
                    )

        service.createRecurringTask =
            (payload, recurringTasks, alerts) ->
                $http.post("/recurring-task", payload)
                    .success( (body, status, headers, config) ->
                        task = body.task
                        newTask = new RecurringTask(
                            task.id, task.description, task.active, task.enabled, task.frequency, 'show', task.description)
                        recurringTasks.push(newTask)
                    )
                    .error( (body, status, headers, config) ->
                        alert = new Alert(body['error_message'])
                        alerts.push(alert)
                    )

        service.askForUpdate = (task, payload, alerts) ->
            $http.put("/unique-task/#{task.id}", payload)
                .success( (body, status, headers, config) -> task.update(payload) )
                .error( (body, status, headers, config) ->
                    alert = new Alert(body['error_message'])
                    alerts.push(alert)
                )

        service.askForDelete = (type, task, onSuccess, onFailure) ->
            $http.delete("/#{type}-task/#{task.id}")
                .success(onSuccess)
                .error(onFailure)

        service
    ])
