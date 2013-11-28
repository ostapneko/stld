stldAppModule = angular.module('stldApp', ['stldApp.filter'])

stldAppModule
    .controller('TaskCtrl', ['$scope', '$http', ($scope, $http) ->
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
        $scope.createMode         = false
        $scope.newTaskDescription = ""

        $scope.getTasks = ->
            $http.get('/tasks')
                .success( (body, status, headers, config) ->
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
                )

        $scope.setFilter = (f) ->
            $scope.tasksDisplayed = { unique: true, recurring: true }
            $scope.taskFilter = f

        $scope.filterTask = ->
            { active: $scope.taskFilter == "thisWeek" }

        $scope.toggleDisplay = (prop) ->
            $scope.tasksDisplayed[prop] = !$scope.tasksDisplayed[prop]

        $scope.toggleCreateMode = (bool) ->
            $scope.createMode = bool

        $scope.createUniqueTask = (description) ->
            payload =
                description: description
                active: $scope.setStatus($scope.taskFilter)
            $scope.try_create(payload)

        $scope.try_create = (payload) ->
            $http.post("/unique-task", payload)
                .success( (body, status, headers, config) ->
                    task = body.task
                    newTask = new UniqueTask(
                        task.id, task.description, task.active, 'show', task.description)
                    $scope.createMode = false
                    $scope.uniqueTasks.push(newTask)
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
            $http.put("/unique-task/#{task.id}", payload)
                .success( (body, status, headers, config) ->
                    task.update(payload)
                )
                .error ( (body, status, headers, config) ->
                    console.log(body, status, headers, config)
                )

        $scope.deleteUniqueTask    = (task) -> $scope.deleteTask("unique", task)
        $scope.deleteRecurringTask = (task) -> $scope.deleteTask("recurring", task)

        $scope.deleteTask = (type, task) ->
            $http.delete("#{type}-task/#{task.id}")
                .success( (body, status, headers, config) ->
                    tasks = if type == "unique" then $scope.uniqueTasks else $scope.recurringTasks
                    i = tasks.indexOf(task)
                    tasks.splice(i, 1)
                )
                .error ( (body, status, headers, config) ->
                    console.log(body, status, headers, config)
                )

        $scope.getTasks()
    ])
