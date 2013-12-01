stldAppModule = angular.module('stldApp', ['stldApp.filter', 'taskServiceModule'])

stldAppModule
    .controller('TaskCtrl', ['$scope', '$http', 'taskService', ($scope, $http, taskService) ->
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

        $scope.uniqueTasks        = []
        $scope.recurringTasks     = []
        $scope.tasksDisplayed     = { unique: true, recurring: true }
        $scope.taskFilter         = "thisWeek"
        $scope.createUniqueMode         = false
        $scope.createRecurringMode      = false
        $scope.newTaskDescription = ""

        $scope.getTasks = ->
            onSuccess = (body, status, headers, config) ->
                $scope.uniqueTasks = (new UniqueTask(
                    t.id,
                    t.description,
                    t.active,
                    'show',
                    t.description
                ) for t in body["uniqueTasks"])
                $scope.recurringTasks = (new RecurringTask(
                    t.id,
                    t.description,
                    t.active,
                    t.enabled,
                    'show',
                    t.description
                ) for t in body["recurringTasks"])

            onFailure = (body, status, headers, config) -> console.log(body, status)

            taskService.askForGet(onSuccess, onFailure)

        $scope.createUniqueTask = (description) ->
            payload =
                description: description
                active: $scope.setStatus($scope.taskFilter)
            $scope.try_create_unique(payload)

        $scope.createRecurringTask = (descriptioni, frequency) ->
            payload =
                description: description
                active: $scope.setStatus($scope.taskFilter)
                frequency: frequency
                enabled: enabled
            $scope.try_create_recurring(payload)

        $scope.try_create_unique = (payload) ->
            $http.post("/unique-task", payload)
                .success( (body, status, headers, config) ->
                    task = body.task
                    newTask = new UniqueTask(
                        task.id, task.description, task.active, 'show', task.description)
                    $scope.createUniqueMode = false
                    $scope.uniqueTasks.push(newTask)
                    $scope.newTaskDescription = ""
                )
                .error( (body, status, headers, config) ->
                    console.log(body, status, headers, config)
                )

        $scope.try_create_recurring = (payload) ->
            $http.post("/recurring-task", payload)
                .success( (body, status, headers, config) ->
                    task = body.task
                    newTask = new RecurringTask(
                        task.id, task.description, task.active, task.enabled, 'show', task.description)
                    $scope.createRecurringMode = false
                    $scope.RecurringTasks.push(newTask)
                    $scope.newTaskDescription = ""
                )
                .error( (body, status, headers, config) ->
                    console.log(body, status, headers, config)
                )

        $scope.setStatus = (filter) ->
            filter == "thisWeek"

        $scope.updateUniqueTaskDescription = (task) ->
            payload =
                id: task.id
                description: task.tempDescription
                active: task.active
            $scope.try_update(task, payload)

        $scope.toggleActivity = (task) ->
            payload =
                id: task.id
                description: task.description
                active: !task.active
            $scope.try_update(task, payload)

        $scope.try_update = (task, payload) ->
            onSuccess = (body, status, headers, config) -> task.update(payload)
            onFailure = (body, status, headers, config) -> console.log(body, status)

            taskService.askForUpdate(task, payload, onSuccess, onFailure)

        $scope.deleteUniqueTask    = (task) -> $scope.deleteTask("unique", task)
        $scope.deleteRecurringTask = (task) -> $scope.deleteTask("recurring", task)

        $scope.deleteTask = (type, task) ->
            onSuccess = (body, status, headers, config) ->
                tasks = if type == "unique" then $scope.uniqueTasks else $scope.recurringTasks
                i = tasks.indexOf(task)
                tasks.splice(i, 1)
            onFailure = (body, status, headers, config) -> console.log(body, status)

            taskService.askForDelete(type, task, onSuccess, onFailure)

        $scope.setFilter = (f) ->
            $scope.tasksDisplayed = { unique: true, recurring: true }
            $scope.taskFilter = f

        $scope.filterTask = ->
            { active: $scope.taskFilter == "thisWeek" }

        $scope.toggleDisplay = (prop) ->
            $scope.tasksDisplayed[prop] = !$scope.tasksDisplayed[prop]

        $scope.toggleCreateMode = (bool, taskType) ->
            if taskType == 'unique'
                $scope.createUniqueMode = bool
            else
                $scope.createRecurringMode = bool


        $scope.getTasks()
    ])
