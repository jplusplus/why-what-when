MONTHS = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
]

(angular.module 'www').directive 'timeline', ['$location', ($location) ->
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
            if scope.data? and scope.zoomLevel is 0
                scope.zoomLevel = 1
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
                return style

            getLitteralMonth = (date)->
                return MONTHS[date.getMonth()]

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

            scope.loadLapse = (lapse)->
                params = 
                    begin: new Date(lapse.start_date).toISOString()
                    end: new Date(lapse.end_date).toISOString()
                $location.search(params)


            scope.getEvents = ()->
                if scope.data?
                    [scope.data, getTodayEvent()]
                else
                    [getTodayEvent()]

            scope.lapseTitle = ()->
                zoom = scope.zoomLevel
                event_date = new Date(scope.data.start_date) if scope.data?
                if zoom is 0
                    return "Today is October 6, 2013"
                else if zoom is 1
                    lapse_year = (new Date()).getFullYear() - event_date.getFullYear()
                    return "Decade: Cuban missile crisis happened 52 years ago"
                else if zoom is 2
                    year  = d3.time.year(event_date).getFullYear()
                    return "#{year}: Height of the crisis - 13 days in October"
                else if zoom is 3
                    month = d3.time.month(event_date)
                    year  = d3.time.year(event_date).getFullYear()
                    month_litteral = getLitteralMonth(month)
                    return "#{month_litteral} #{year}"

            scope.getLapseClass = (lapse)->
                klass = 'lapse' 
                if scope.zoomLevel < 3
                    klass += ' clickable'
                if lapse.title is 'Today'
                    klass += ' today'
                return klass

            scope.lapseTicks = ()->
                if scope.zoomLevel is 1
                    ticks = window.getDecadeRange(new Date scope.data.start_date)
                    start = new Date (do ticks[0].getFullYear), 1, 1
                    end = new Date (do ticks[1].getFullYear), 10, 31
                    [
                        {
                            date : start
                            label : start.getFullYear()
                        }
                        {
                            date : end
                            label : end.getFullYear()
                        }
                    ]
                else if scope.zoomLevel is 2
                    ticks = [0..11]
                    _.map ticks, (i) =>
                        d = new Date scope.data.start_date
                        d = new Date (do d.getFullYear), i, 14
                        month_str = MONTHS[i]

                        return {
                            date : d
                            label : month_str.substr(0,3)
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
                console.log "zoomLapse !"
                if scope.zoomLevel < MAX_ZOOM_LEVEL
                    scope.zoomLevel++

            scope.unzoomLapse = ()->
                if scope.zoomLevel > 0
                    scope.zoomLevel--
                    params = 
                        begin: null
                        end: null
                    $location.search(params)

               # return unless scope.data? and scope.data.sub_events?
            lapseRange   = getLapseRange() 
            scope.timeline = scale.domain(lapseRange).range([0, workspaceWidth - 25])
    ]