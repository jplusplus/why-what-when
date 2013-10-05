MONTHS = [
    'January',
    'February',
    'March',
    'April',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
]

(angular.module 'www').directive 'timeline', [() ->
    restrict : "E"
    replace : yes
    templateUrl : "/partials/timeline.html"
    scope: 
        data: '='
    link : (scope, element, attrs) ->
        MAX_ZOOM_LEVEL = 3
        workspace = d3.select(element[0])
        workspaceWidth = $(element).innerWidth()
        workspaceHeight = $(element).innerHeight()
        scale = d3.time.scale()
        monitored = ['data', 'zoomLevel']
        scope.$watch monitored.join('||'), ->update()

        update = ()->
            unless scope.data?
                scope.zoomLevel = 0
            else 
                scope.zoomLevel = 1

            scope.lapseStyle = (lapse)->
                console.log "lapseStyle(", lapse, ")"
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
                return style

            getLitteralMonth = (date)->
                return MONTHS[date.getMonth()]

            getLapseRange = ()->
                zoom = scope.zoomLevel
                console.log 'zoom level: ', zoom
                event_date = new Date(scope.data.start_date) if scope.data?
                if zoom is 0
                    return window.getYearRange(new Date()) 
                else if zoom is 1
                    return window.getDecadeRange(event_date)
                else if zoom is 2
                    return window.getYearRange(event_date)

                else if zoom is 3
                    return window.getMonthRange(event_date)

            getTodayEvent = ()->
                yearRange = window.getYearRange(new Date())
                return {
                    title: 'Today'
                    start_date: (new Date()).toString()
                    end_date: yearRange[1].toString()
                }
            scope.getEvents = ()->
                zoom = scope.zoomLevel
                if zoom is 0
                    return getTodayEvent()
                else if zoom is 1 or zoom is 2
                    console.log scope.data
                    return [scope.data]
                else if zoom is 3
                    return scope.data.sub_events


            scope.lapseTitle = ()->
                zoom = scope.zoomLevel
                event_date = new Date(scope.data.start_date) if scope.data?
                if zoom is 0
                    return "Today"
                else if zoom is 1
                    return "Decade"
                else if zoom is 2
                    year  = d3.time.year(event_date).getFullYear()
                    return "#{year}"
                else if zoom is 3
                    month = d3.time.month(event_date)
                    year  = d3.time.year(event_date).getFullYear()
                    month_litteral = getLitteralMonth(month)
                    return "#{month_litteral} #{year}"

            scope.lapseTicks = ()->

            scope.zoomLapse = ()->
                if scope.zoomLevel < MAX_ZOOM_LEVEL
                    scope.zoomLevel++

            scope.unzoomLapse = ()->
                if scope.zoomLevel > 0
                    scope.zoomLevel--


               # return unless scope.data? and scope.data.sub_events?
            lapseRange   = getLapseRange() 
            console.log lapseRange
            scope.timeline = scale.domain(lapseRange).range([0, workspaceWidth])
    ]