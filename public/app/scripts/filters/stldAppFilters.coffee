stldAppModuleFilter = angular.module('stldApp.filter', [])

stldAppModuleFilter
    .filter('expandClass', ->
        (tDisplayed, taskType) ->
            if tDisplayed[taskType] then "fa-caret-down" else "fa-caret-right"
    )
