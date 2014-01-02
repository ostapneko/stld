stldAppModule = angular.module('stldApp', ['stldApp.filter', 'taskServiceModule'])

stldAppModule
    .controller('TaskCtrl', ['$scope', '$http', 'taskService', ($scope, $http, taskService) ->

        $scope.uniqueTasks         = []
        $scope.recurringTasks      = []
        $scope.alerts              = []
        $scope.tasksDisplayed      = { unique: true, recurring: true }
        $scope.taskFilter          = "thisWeek"
        $scope.createMode          = { unique: false, recurring: false }
        $scope.newTaskDescription  = ""
        $scope.newTaskEnabled      = true
        $scope.newTaskFrequency    = ""

        $scope.getTasks = ->
            $scope.uniqueTasks = []
            $scope.recurringTasks = []
            taskService.getAllTasks($scope.uniqueTasks, $scope.recurringTasks)

        $scope.createUniqueTask = (description) ->
            payload =
                description: description
                active: $scope.setStatus($scope.taskFilter)

            taskService.createUniqueTask(payload, $scope.uniqueTasks, $scope.alerts)
                .success( ->
                    $scope.toggleCreateMode('unique')
                    $scope.newTaskDescription = ""
                )

        $scope.createRecurringTask = (description, enabled, frequency) ->
            payload =
                description: description
                active: $scope.setStatus($scope.taskFilter)
                frequency: frequency
                enabled: enabled

            taskService.createRecurringTask(payload, $scope.recurringTasks, $scope.alerts)
                .success( ->
                    $scope.toggleCreateMode('recurring')
                    $scope.newTaskDescription = ""
                    $scope.newTaskEnabled     = true
                    $scope.newTaskFrequency   = ""
                )

        $scope.setStatus = (filter) ->
            filter == "thisWeek"

        $scope.updateUniqueTaskDescription = (task) ->
            payload =
                id: task.id
                description: task.tempDescription
                active: task.active
            taskService.askForUpdate("unique", task, payload, $scope.alerts)

        $scope.updateRecTask = (task) ->
            payload =
                id: task.id
                description: task.tempDescription
                active: task.active
                frequency: task.tempFrequency
            taskService.askForUpdate("recurring", task, payload, $scope.alerts)

        $scope.toggleActivity = (task) ->
            payload =
                id: task.id
                description: task.description
                active: !task.active
            taskService.askForUpdate("unique", task, payload, $scope.alerts)

        $scope.deleteUniqueTask    = (task) -> $scope.deleteTask("unique", task)
        $scope.deleteRecurringTask = (task) -> $scope.deleteTask("recurring", task)

        #TODO simplify
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

        $scope.toggleCreateMode = (taskType) ->
            $scope.createMode[taskType] = !$scope.createMode[taskType]

        $scope.removeAlert = (alert) ->
            newAlerts = $scope.alerts.filter (a) -> a isnt alert
            $scope.alerts = newAlerts

        $scope.getTasks()
    ])
