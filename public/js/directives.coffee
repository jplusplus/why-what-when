(angular.module 'www').directive 'timeline', [() ->
    restrict : "E"
    replace : yes
    templateUrl : "/partials/timeline.html"
    scope: 
        data: '='
        zoomLevel: '='
    link : (scope, element, attrs) ->
        workspace = d3.select(element[0])
        workspaceWidth = $(element).innerWidth()
        workspaceHeight = $(element).innerHeight()
        scale = d3.time.scale()
        monitored = ['data']
        scope.$watch 'data', ->update()

        update = ()->
            # return unless scope.data? and scope.data.sub_events?
            scope.events = scope.data.sub_events 
            start_str = scope.data.start_date
            start_date = new Date(start_str)
            console.log 'starting date: ', start_date
            ###
            if scope.zoomLevel is 0 # should right now, no events
                range = getCurrentYearRange()
                events = [today]
            else if scope.zoomLevel is 1 # should be a decade for the selected event
            else if scope.zoomLevel is 2 # should be a year
            else if scope.zoomLevel is 3 # should be a month
            ###

            begin = d3.time.month(start_date)
            end   = begin.setMonth(begin.getMonth()+1)
            begin = new Date(start_date.getFullYear(), start_date.getMonth() , 1) 
            end = new Date(begin.getFullYear(), begin.getMonth() + 1, 0)
            end.setHours(-24)
            
            console.log 'update()', begin, end

            scope.timeline = scale.domain([begin, end]).range([0, workspaceWidth])
            scope.lapseStyle = (lapse)->
                return null unless lapse?
                begin = new Date(lapse.start_date)
                end = new Date(lapse.end_date)
                beginOffsetX = scope.timeline(begin)
                endOffsetX = scope.timeline(end)
                console.log 'lapseStyle()', begin, end
                console.log 'lapseStyle()', beginOffsetX, endOffsetX 


                width = Math.floor(endOffsetX - beginOffsetX) + 'px'
                left  = (beginOffsetX * 100 / workspaceWidth) + '%'  
                style = 
                    position: "absolute"
                    left: left
                    width: width
                    height: workspaceHeight 
                console.log style

                return style


    ]