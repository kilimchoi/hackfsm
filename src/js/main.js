'use strict';
// TODO: integrate masonry with gallery
//var container = document.querySelector('#container');
//var msnry = new Masonry( container, {
        //itemSelector: '.item'
//});

/* Controllers */

var galleryApp = angular.module('galleryApp', []);

galleryApp.controller('GalleryGridCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.items = [];
  $http.get('data/images.json').success(function(data) {
    $scope.items = data;
  });
}]);
