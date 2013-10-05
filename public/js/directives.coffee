(angular.module 'www').directive 'timeline', [() ->
    restrict : "E"
    replace : yes
    templateUrl : "/partials/timeline.html"
    scope: 
        data: '='
    link : (scope, element, attrs) ->
        workspace = d3.select(element[0])
        workspaceWidth = $(element).innerWidth()
        scale = d3.time.scale()
        monitored = ['data']
        scope.$watch 'data', ->update()

        update = ()->
            console.log scope.data
            scope.events = scope.data.events 
            start_str = scope.data.begin_date
            year = new Date(start_str).getFullYear()
            begin = new Date(year)
            end = new Date(31, 12, year)

            scope.timeline = scale.domain([begin, end]).range([0, workspaceWidth])

            scope.lapseStyle = (lapse)->
                console.log lapse
                beginOffsetBegin = scope.timeline(new Date(lapse.start_date))
                endOffsetX = scope.timeline(new Date(lapse.end_date)) 

                width = endOffsetX - beginOffsetBegin
                style = 
                    position: "absolute"
                    left: beginOffsetBegin
                    width: width
                console.log style


    ]