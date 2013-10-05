class SearchCtrl
    @$inject: ['$scope', '$location', '$http']
    constructor: (@scope, @location, @http)->
        console.log('SearchCtrl init !')

        (@http.get '/cubancrisis.json').success (data) =>
            @scope.data = data

angular.module('www').controller 'SearchCtrl', SearchCtrl