class SearchCtrl
    @$inject: ['$scope', '$location', '$http']
    constructor: (@scope, @location, @http)->
        console.log('SearchCtrl init !')

        @lastStep = 4

        search = do @location.search
        @step = search.step || 0

        do @setButtons

        @scope.goBack = @goBack
        @scope.goForward = @goForward

        (@http.get '/cubancrisis.json').success (data) =>
            @scope.data = data
            @scope.currentTopic = data

    setButtons : () =>
        @scope.canBack = @step > 0
        @scope.canForward = @step < @lastStep

    goBack : () =>
        @location.search 'step', --@step
        do @setButtons

    goForward : () =>
        @location.search 'step', ++@step
        do @setButtons

angular.module('www').controller 'SearchCtrl', SearchCtrl