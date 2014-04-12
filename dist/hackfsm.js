'use strict';
// TODO: integrate masonry with gallery
//var container = document.querySelector('#container');
//var msnry = new Masonry( container, {
        //itemSelector: '.item'
//});

/* Controllers */

//var galleryApp = angular.module('galleryApp', []);
//var masonry = angular.module('galleryApp', ['wu.masonry']);

angular.module('galleryApp', ['wu.masonry']).controller('GalleryGridCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.bricks = [];
  $http.get('data/images.json').success(function(data) {
    $scope.bricks = data;
  });
}]);
