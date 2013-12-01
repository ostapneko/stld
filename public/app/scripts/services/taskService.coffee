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
    constructor: (@id, @description, @active, @enabled, @mode, @tempDescription) ->

    displayAction: ->
      if @enabled then "Disable" else "Enable"

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
                        'show',
                        t.description
                    )) for t in body["recurringTasks"]
                )
                .error( (body, status, headers, config) ->
                    console.log(body, status)
                )

        service.createUniqueTask =
            (payload, uniqueTasks) ->
                $http.post("/unique-task", payload)
                    .success( (body, status, headers, config) ->
                        task = body.task
                        newTask = new UniqueTask(
                            task.id, task.description, task.active, 'show', task.description)
                        uniqueTasks.push(newTask)
                    )
                    .error( (body, status, headers, config) ->
                        console.log(body, status, headers, config)
                    )

        service.createRecurringTask =
            (payload, recurringTasks) ->
                $http.post("/recurring-task", payload)
                    .success( (body, status, headers, config) ->
                        task = body.task
                        newTask = new RecurringTask(
                            task.id, task.description, task.active, task.enabled, 'show', task.description)
                        createRecurringMode = false
                        recurringTasks.push(newTask)
                    )
                    .error( (body, status, headers, config) ->
                        console.log(body, status, headers, config)
                    )

        service.askForUpdate = (task, payload, onSuccess, onFailure) ->
            $http.put("/unique-task/#{task.id}", payload)
                .success(onSuccess)
                .error(onFailure)

        service.askForDelete = (type, task, onSuccess, onFailure) ->
            $http.delete("/#{type}-task/#{task.id}")
                .success(onSuccess)
                .error(onFailure)

        service
    ])
