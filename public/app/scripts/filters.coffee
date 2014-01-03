angular.module('stldApp.filters', [])
  .filter('expandClass', ->
    (tDisplayed, taskType) ->
      if tDisplayed[taskType] then "fa-caret-down" else "fa-caret-right"
  )
