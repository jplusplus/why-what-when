angular.module("wwwFilters", []).filter('dateFilter', [() ->
    (array, start, end) ->
        start = new Date start
        end = new Date end
        out = []
        _.map array, (elem) =>
            if (new Date elem.start_date) >= start and (new Date elem.end_date) <= end
                out.push elem
        out
])