class SearchCtrl
    @$inject: ['$scope', '$location']
    constructor: (@scope, @location)->
        console.log('SearchCtrl init !')

angular.module('www').controller 'SearchCtrl', SearchCtrl