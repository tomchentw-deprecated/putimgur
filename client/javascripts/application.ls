angular.module 'application' <[
  ngSanitize
  ui.bootstrap
  ng-form-data
]>
.controller 'IndexCtrl' class

  createAlbum: ->
    const {$scope} = @
    @$http do
      method: 'POST'
      url: 'https://api.imgur.com/3/album/'
      headers: do
        'Authorization': "Client-ID #{ $scope.binding.clientId }"
    .then !({data}) ->
      const album = data.data
      $scope.binding <<< {
        albumId: album.id
        albumDeleteHash: album.deletehash
      }

  submit: ->
    const {$scope} = @
    @$http do
      method: 'POST'
      url: '/api/1/bindings'
      data: $scope.binding
    .then !({data}) ->
      $scope.binding.token = data.result.token

  tryUploadImage: ->
    const {$http, $scope} = @
    $http do
      method: 'POST'
      url: '/3/image'
      headers: do
        'Authorization': "Client-ID #{ $scope.binding.clientId }"
      data: $scope.newImg
    .then ({data}) ->
      /*!
       * imgur bug, it won't return title and description
       * need to get it again
       */
      $http do
        url: "https://api.imgur.com/3/image/#{ data.data.id }"
        headers: do
          'Authorization': "Client-ID #{ $scope.binding.clientId }"
    .then !({data}) ->
      $scope.image = data.data

  deleteTryImage: ->
    const {$scope} = @

    @$http.delete "https://api.imgur.com/3/image/#{ $scope.image.deletehash }"
    .then !->
      $scope.image = void

  @$inject = <[
     $scope   $http ]>
  !(@$scope, @$http) ->
