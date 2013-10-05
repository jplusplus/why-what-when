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
        unless scope.data? and scope.zoomLevel?
            scope.zoomLevel = 0
        else 
            scope.zoomLevel = 1
        workspace = d3.select(element[0])
        workspaceWidth = $(element).innerWidth()
        workspaceHeight = $(element).innerHeight()
        scale = d3.time.scale()
        monitored = ['data', 'zoomLevel']
        for monitor in monitored
            do()->
                scope.$watch monitor, ->update()

        update = ()->
            scope.lapseStyle = (lapse)->
                # console.log "lapseStyle(", lapse, ")"
                return null unless lapse?
                begin = new Date(lapse.start_date)
                end = new Date(lapse.end_date)
                beginOffsetX = scope.timeline(begin)
                endOffsetX = scope.timeline(end)
                width = Math.floor(endOffsetX - beginOffsetX) + 'px'
                left  = (beginOffsetX * 100 / workspaceWidth) + '%'  
                style = 
                    position: "absolute"
                    left: left
                    width: width
                    height: workspaceHeight 
                return style

            getLitteralMonth = (date)->
                return MONTHS[date.getMonth() - 1]

            getLapseRange = ()->
                zoom = scope.zoomLevel
                event_date = new Date(scope.data.start_date) if scope.data?
                if zoom is 0
                    range = window.getYearRange(new Date()) 
                    scope.start = ""
                    scope.end = ""
                else if zoom is 1
                    range = window.getDecadeRange(event_date)
                    scope.start = do range[0].getFullYear
                    scope.end = do range[1].getFullYear
                else if zoom is 2
                    range = window.getYearRange(event_date)
                    scope.start = range[0].toLocaleFormat "%B"
                    scope.end = range[1].toLocaleFormat "%B"
                else if zoom is 3
                    range = window.getMonthRange(event_date)
                    scope.start = do range[0].getDate
                    scope.end = do range[1].getDate
                return range

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
                if scope.zoomLevel is 1
                    ticks = window.getDecadeRange(new Date scope.data.start_date)
                    start = new Date (do ticks[0].getFullYear), 1, 1
                    end = new Date (do ticks[1].getFullYear), 10, 31
                    [
                        {
                            date : start
                            label : start.toLocaleFormat "%Y"
                        }
                        {
                            date : end
                            label : end.toLocaleFormat "%Y"
                        }
                    ]
                else if scope.zoomLevel is 2
                    ticks = [0..11]
                    _.map ticks, (i) =>
                        d = new Date scope.data.start_date
                        d = new Date (do d.getFullYear), i, 14
                        {
                            date : d
                            label : d.toLocaleFormat "%b"
                        }
                else if scope.zoomLevel is 3
                    current_month = new Date scope.data.start_date
                    previous_month = new Date (do current_month.getYear), (do current_month.getMonth) + 1, 0
                    ticks = [1..(do previous_month.getDate)]
                    _.map ticks, (i) =>
                        d = new Date (do current_month.getFullYear), (do current_month.getMonth), i
                        {
                            date : d
                            label : do d.getDate
                        }
                else
                    []

            scope.tickStyle = (tick)->
                return null unless tick?
                begin = new Date(tick.date)
                beginOffsetX = scope.timeline(begin)
                left  = (beginOffsetX * 100 / workspaceWidth)
                width = if scope.zoomLevel in [3] then 16 else 30
                style =
                    position: "absolute"
                    left: "calc(#{left}% - #{width / 2}px)"
                    width: width + 'px'
                return style

            scope.zoomLapse = ()->
                if scope.zoomLevel < MAX_ZOOM_LEVEL
                    scope.zoomLevel++

            scope.unzoomLapse = ()->
                if scope.zoomLevel > 0
                    scope.zoomLevel--

               # return unless scope.data? and scope.data.sub_events?
            lapseRange   = getLapseRange() 
            scope.timeline = scale.domain(lapseRange).range([0, workspaceWidth])
    ]