angular.module("wwwServices", [])

class DataProvider

    @$inject : ['$rootScope', '$location', '$http']

    constructor : (@rootScope, @location, @http) ->

angular.module('wwwServices').service "DataProvider", DataProvider