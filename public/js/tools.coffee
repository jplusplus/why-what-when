
window.getDecadeRange = (d) =>
    if not (d instanceof Date)
        d = (new Date d)    
    start = (Math.floor ((do d.getFullYear) / 10)) * 10
    end = start + 10
    [(new Date start, 0, 1), (new Date end, 11, 31)]

window.getYearRange = (d)=>
    begin = d3.time.year(d)
    end   = new Date(d.getFullYear() + 1, 0, 0)
    [begin, end]

window.getMonthRange = (d)=>
    begin = d3.time.month(d)
    end = new Date(begin.getFullYear(), begin.getMonth()+1, 0)
    [begin, end]