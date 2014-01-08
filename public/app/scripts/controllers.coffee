angular.module('stldApp.controllers', [])
  .controller('TaskCtrl', ['$scope', '$http', 'taskService', ($scope, $http, taskService) ->
    $scope.alert               = ""
    $scope.tasksDisplayed      = { unique: true, recurring: true }
    $scope.taskFilter          = "thisWeek"
    $scope.createMode          = { unique: false, recurring: false }
    $scope.newTaskDescription  = ""
    $scope.newTaskFrequency    = ""

    $scope.getTasks = ->
      taskService.getTasks()
        .then(
          (tasks) ->
            $scope.uniqueTasks = tasks.unique
            $scope.recurringTasks = tasks.recurring
          ,
          (error) -> $scope.alert = error
        )

    $scope.startNewSprint = ->
      taskService.startNewSprint()
        .catch( (error) -> $scope.alert = error )

    $scope.createUniqueTask = (description) ->
      payload =
        description: description
        active: $scope.isThisWeekDisplayed()

      taskService.createUnique(payload)
        .then(
          (task) ->
            $scope.uniqueTasks.push(task)
            $scope.toggleCreateMode('unique')
            $scope.newTaskDescription = ""
          ,
          (error) -> $scope.alert = error
        )

    $scope.createRecurringTask = (description, frequency) ->
      payload =
        description: description
        active: $scope.isThisWeekDisplayed()
        frequency: frequency
        enabled: true

      taskService.createRecurring(payload)
        .then(
          (task) ->
            $scope.recurringTasks.push(task)
            $scope.toggleCreateMode('recurring')
            $scope.newTaskDescription = ""
            $scope.newTaskFrequency   = ""
          ,
          (error) -> $scope.alert = error
        )

    $scope.updateTask = (type, task) ->
      payload =
        id: task.id
        description: task.tempDescription
        active: task.active
        frequency: task.tempFrequency if type == "recurring"

      taskService.update(type, task, payload)
        .catch( (error) -> $scope.alert = error )

    $scope.setAsDone = (task) ->
      payload =
        id: task.id
        description: task.description
        frequency: task.frequency
        status: "done"

      taskService.update("recurring", task, payload)
        .catch( (error) -> $scope.alert = error )

    $scope.deleteTask = (type, task) ->
      taskService.delete(type, task)
        .then(
          (task) ->
            tasks = if type == "unique" then $scope.uniqueTasks else $scope.recurringTasks
            i = tasks.indexOf(task)
            tasks.splice(i, 1)
          ,
          (error) -> $scope.alert = error
        )

    $scope.isThisWeekDisplayed = ->
      $scope.taskFilter == "thisWeek"

    $scope.toggleActivity = (task) ->
      payload =
        id: task.id
        description: task.description
        active: !task.active

      taskService.update("unique", task, payload)
        .catch( (error) -> $scope.alert = error )

    $scope.setFilter = (f) ->
      $scope.tasksDisplayed = { unique: true, recurring: true }
      $scope.taskFilter = f

    $scope.filterTask = ->
      { active: $scope.isThisWeekDisplayed() }

    $scope.toggleDisplay = (prop) ->
      $scope.tasksDisplayed[prop] = !$scope.tasksDisplayed[prop]

    $scope.toggleCreateMode = (taskType) ->
      $scope.createMode[taskType] = !$scope.createMode[taskType]

    $scope.alertPresent = ->
      $scope.alert.length > 0

    $scope.removeAlert = ->
      $scope.alert = ""

    $scope.sunday = ->
      d = new Date()
      d.getDay() == 6

    $scope.getTasks()
])
