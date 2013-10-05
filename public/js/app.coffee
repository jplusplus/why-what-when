# Declare services once
angular.module('whenWasItService', [])


angular
    .module('whenWasIt', ["ui.bootstrap", "restangular", "whenWasItServices", "whenWasItFilters", "ngCookies"])
    .run(
        [             
            '$rootScope', 
            '$location',
            ($rootScope, $location)->
                # Location available within templates
                $rootScope.location = $location;
        ]
    )
    .config(
        [
            '$interpolateProvider', 
            '$routeProvider', 
            'RestangularProvider',  
            '$httpProvider',
            '$cookiesProvider',
            ($interpolateProvider, $routeProvider, RestangularProvider, $http, $cookies)->
                RestangularProvider.setBaseUrl("/api")
                RestangularProvider.setRequestSuffix('/')
                # All services will be cached
                RestangularProvider.setDefaultHttpFields cache: true   
                # Add csrf token into default post headers
                $http.defaults.headers.post['X-CSRFToken'] = $cookies.csrftoken                
                # Avoid a conflict with Django Template's tags
                $interpolateProvider.startSymbol '[['
                $interpolateProvider.endSymbol   ']]'
                # Bind routes to the controllers
                $routeProvider
                    .when('/search/', 
                        controller: 'tabsCtrl'
                        templateUrl: "./partials/search.jade"
                        reloadOnSearch: false
                    )
        ]
    )
