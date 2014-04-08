angular.module 'application' <[
  ngSanitize
  ui.bootstrap
]>
.controller 'IndexCtrl' class

  submit: ->
    const {$scope} = @
    @$http do
      method: 'POST'
      url: '/api/1/bindings'
      data: $scope.binding
    .then !({data}) ->
      $scope.binding.token = data.result.token

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

  @$inject = <[
     $scope   $http ]>
  !(@$scope, @$http) ->