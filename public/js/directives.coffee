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
        scope.zoomLevel = 0
        workspaceWidth = $(element).innerWidth()
        workspaceHeight = $(element).innerHeight()
        scale = d3.time.scale()
        monitored = ['data', 'zoomLevel']
        for monitor in monitored
            do()->
                scope.$watch monitor, ->update()

        update = ()->
            scope.lapseStyle = (lapse, parent_lapse)->
                # console.log "lapseStyle(", lapse, ")"
                return null unless lapse?
                begin = new Date(lapse.start_date)
                end = new Date(lapse.end_date)
                beginOffsetX = scope.timeline(begin)
                endOffsetX = scope.timeline(end)
                widthRaw = Math.floor(endOffsetX - beginOffsetX) 
                width = widthRaw + 'px'
                leftRatio  = ((beginOffsetX * 100) / workspaceWidth) + '%'
                if parent_lapse? and parent_lapse isnt null
                    parent_style = this.lapseStyle(parent_lapse)
                    leftX = beginOffsetX - parent_style.leftRaw
                    ratio =  (leftX * 100)  / parent_style.widthRaw
                    leftRatio = ratio + '%'
                style = 
                    position: "absolute"
                    left: leftRatio
                    leftRaw: beginOffsetX
                    width: width
                    widthRaw: widthRaw
                    height: workspaceHeight 
                return style

            getLitteralMonth = (date)->
                return MONTHS[date.getMonth() - 1]

            getLapseRange = ()->
                zoom = scope.zoomLevel
                event_date = new Date(scope.data.start_date) if scope.data?
                if zoom is 0
                    range = window.getYearRange(new Date()) 
                else if zoom is 1
                    range = window.getDecadeRange(event_date)
                else if zoom is 2
                    range = window.getYearRange(event_date)

                else if zoom is 3
                    range = window.getMonthRange(event_date)
                return range

            getTodayEvent = ()->
                yearRange = window.getYearRange(new Date())
                return {
                    title: 'Today'
                    start_date: (new Date()).toString()
                    end_date: yearRange[1].toString()
                }
            scope.getEvents = ()->
                if scope.data?
                    [scope.data, getTodayEvent()]
                else
                    [getTodayEvent()]

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
            scope.timeline = scale.domain(lapseRange).range([0, workspaceWidth])
    ]