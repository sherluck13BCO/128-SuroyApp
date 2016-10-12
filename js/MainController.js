app.controller('MainController', ($scope, $http) => {
  $scope.title = ''
  $http.get('/getTitle/')
  	.success((data) => {
    	$scope.title = data;
    	console.log(data);
  	})
  	.error((error) => {
    	console.log('Error: ' + error);
  	});
})
