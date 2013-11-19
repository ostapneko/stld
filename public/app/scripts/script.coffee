stldAppModule = angular.module('stldApp', [])

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

        class RecurringTask extends Task
            constructor: (@id, @description, @active, @enabled, @mode, @tempDescription) ->

            displayAction: ->
              if @enabled then "Disable" else "Enable"

        $scope.uniqueTasks    = []
        $scope.recurringTasks = []
        $scope.taskFilter     = { active: true }
        $scope.tasksDisplayed = { unique: true, recurring: true }
        $scope.taskFilter     = "thisWeek"

        $scope.getTasks = ->
            $http.get('/tasks')
                .success( (data, status, headers, config) ->
                    $scope.uniqueTasks = (new UniqueTask(
                        t.id,
                        t.description,
                        t.active,
                        'show',
                        t.description
                    ) for t in data["uniqueTasks"])

                    $scope.recurringTasks = (new RecurringTask(
                        t.id,
                        t.description,
                        t.active,
                        t.enabled,
                        'show',
                        t.description
                    ) for t in data["recurringTasks"])
                )

        $scope.setFilter = (f) ->
            $scope.tasksDisplayed = { unique: true, recurring: true }
            $scope.taskFilter = f

        $scope.filterTask = ->
            { active: $scope.taskFilter == "thisWeek" }

        $scope.toggleDisplay = (prop) ->
            $scope.tasksDisplayed[prop] = !$scope.tasksDisplayed[prop]

        $scope.updateUniqueTaskDescription = (task) ->
            payload =
                id: task.id
                description: task.tempDescription
                active: task.active

            $http.put("/unique-task/#{task.id}", payload)
                .success( (data, status, headers, config) ->
                    task.description = task.tempDescription
                    task.mode = 'show'
                )
                .error ( (data, status, headers, config) ->
                    console.log(data, status, headers, config)
                )

        $scope.deleteUniqueTask = (task) ->
            $http.delete("unique-task/#{task.id}")
                .success( (data, status, headers, config) ->
                    i = $scope.uniqueTasks.indexOf(task)
                    $scope.uniqueTasks.splice(i, 1)
                )
                .error ( (data, status, headers, config) ->
                    console.log(data, status, headers, config)
                )

        $scope.getTasks()
    ])
    .filter('expandClass', ->
        (tDisplayed, taskType) ->
            if tDisplayed[taskType] then "fa-caret-down" else "fa-caret-right"
    )
