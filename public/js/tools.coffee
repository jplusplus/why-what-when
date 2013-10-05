window.getDecade = (d) =>
    if not (d instanceof Date)
        d = (new Date d)
    start = (Math.floor ((do d.getFullYear) / 10)) * 10
    end = start + 10
    [(new Date start, 0, 1), (new Date end, 11, 31)]