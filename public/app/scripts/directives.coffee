angular.module('stldApp.directives', [])
  .directive('stldFocus', ($timeout) ->
    link: (scope, element, attrs) ->
      scope.$watch(attrs.stldFocus, (oldValue, newValue) ->
        $timeout( ->
          element[0].focus()
          scope[attrs.stldFocus] = false
        )
      )
  )
