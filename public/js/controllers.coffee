class SearchCtrl
    @$inject: ['$scope', '$location', '$http']
    constructor: (@scope, @location, @http)->
        console.log('SearchCtrl init !')
        @scope.filters = 
            begin: d3.time.year(new Date())
            end: new Date(new Date().getFullYear() + 1, 0, 0)

        @scope.filters.
        search = do @location.search
        @scope.typeahead_suggestions = ["Cuba crisis"]
        @scope.topic = ''

        @scope.$watch 'topic', () =>
            if @scope.topic? and @scope.topic isnt ''
                (@http.get '/cubancrisis.json').success (data) =>
                    @scope.data = data
                    @scope.currentTopic = data

        @scope.$watch ()=>
                @location.search()
            , 
                @onLapseLoaded

    onLapseLoaded: ()=>
        @scope.filters.beginDate = @location.search().begin
        @scope.filters.endDate = @location.search().end

angular.module('www').controller 'SearchCtrl', SearchCtrl