angular.module('stldApp.controllers', [])
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
      $scope.uniqueTasks         = []
      $scope.recurringTasks      = []
      taskService.getAllTasks($scope.uniqueTasks, $scope.recurringTasks)

    $scope.createUniqueTask = (description) ->
      payload =
        description: description
        active: $scope.setStatus($scope.taskFilter)

      taskService.askForCreate('unique', payload, $scope.uniqueTasks, $scope.alerts)
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

      taskService.askForCreate('recurring', payload, $scope.recurringTasks, $scope.alerts)
        .success( ->
          $scope.toggleCreateMode('recurring')
          $scope.newTaskDescription = ""
          $scope.newTaskEnabled     = true
          $scope.newTaskFrequency   = ""
        )

    $scope.updateTask = (type, task) ->
      payload =
        id: task.id
        description: task.tempDescription
        active: task.active
        frequency: task.tempFrequency if type == 'recurring'
      taskService.askForUpdate(type, task, payload, $scope.alerts)

    $scope.deleteTask = (type, task) ->
      tasks = if type == "unique" then $scope.uniqueTasks else $scope.recurringTasks
      taskService.askForDelete(type, task, tasks)

    $scope.setStatus = (filter) ->
      filter == "thisWeek"

    $scope.toggleActivity = (task) ->
      payload =
        id: task.id
        description: task.description
        active: !task.active
      taskService.askForUpdate("unique", task, payload, $scope.alerts)

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
