(angular.module 'www').directive 'timeline', [() ->
    restrict : "E"
    replace : yes
    templateUrl : "/partials/timeline.html"
    scope:
        data: "="
        startDate: "="
        endDate: "="
    link : (scope, element, attrs) ->
        workspace = d3.select(element[0])
        console.log element
        workspaceWidth = $(element).innerWidth()
        scale = d3.time.scale()

        end = new Date()
        begin = new Date(end.getFullYear())
        
        oneDayInMS  = 1000 * 60 * 60 * 24
        # diffInDays = Math.floor((end.getTime() - begin.getTime()) / oneDayInMS)
        # console.log "diff in days: ", diffInDays
        timeDomain = scale.domain([begin, end])


        addLapse: (begin, end=null)
        console.log timeDomain



]