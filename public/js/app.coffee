# Declare services once

angular
    .module('www', [
        # "restangular", 
        "wwwServices", "wwwFilters", "ngCookies"
    ])
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
            # 'RestangularProvider',  
            '$httpProvider',
            '$cookiesProvider',
            ($interpolateProvider, $routeProvider, $http, $cookies)->
                # RestangularProvider.setBaseUrl("/api")
                # RestangularProvider.setRequestSuffix('/')
                # All services will be cached
                # RestangularProvider.setDefaultHttpFields cache: true   
                # Add csrf token into default post headers
                $http.defaults.headers.post['X-CSRFToken'] = $cookies.csrftoken                
                # Avoid a conflict with Django Template's tags
                # Bind routes to the controllers
                $routeProvider
                    .when('/search/', 
                        controller: 'SearchCtrl'
                        templateUrl: "partials/search.html"
                        reloadOnSearch: false
                    )
        ]
    )
