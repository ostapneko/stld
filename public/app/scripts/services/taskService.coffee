taskServiceModule = angular.module('taskServiceModule', [])

taskServiceModule
    .factory('taskService', ['$http', ($http) ->
         service = {}

         service.askForUpdate = (task, payload, onSuccess, onFailure) ->
             $http.put("/unique-task/#{task.id}", payload)
                 .success(onSuccess)
                 .error(onFailure)

         service.askForDelete = (type, task, onSuccess, onFailure) ->
             $http.delete("#{type}-task/#{task.id}")
                 .success(onSuccess)
                 .error(onFailure)
         service.askForGet = (onSuccess, onFailure) ->
             $http.get('/tasks')
                 .success(onSuccess)
                 .error(onFailure)
         service
    ])
