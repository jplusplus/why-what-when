(angular.module 'www').directive 'timeline', [() ->
    restrict : "E"
    replace : yes
    templateUrl : "/partials/timeline.html"
    link : (scope, element, attrs) ->
]