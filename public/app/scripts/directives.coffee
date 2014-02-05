#The factory function is invoked only once when the compiler matches the directive for the first time
angular.module('stldApp.directives', [])
  .directive('stldFocus', ($timeout) ->
    link = (scope, element, attrs) ->
      scope.$watch(attrs.stldFocus, () ->
        if attrs.stldFocus
          $timeout( -> element[0].focus() )
      )

    link: link
  )
