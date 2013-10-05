angular.module("wwwServices", [])

class DataProvider

    @$inject : ['$rootScope', '$location']

    constructor : (@rootScope, @location) ->

angular.module('wwwServices').service "DataProvider", DataProvider