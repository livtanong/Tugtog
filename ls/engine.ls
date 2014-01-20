# game = {}
themes =
	"beach":
		"bg": "Beach.png"
		"note": "Crab Note.png"
	"rice":
		"bg": "Rice Field.png"
		"note": "Rice Note.png"

state = {}

# $ -> 
# 	$.when(
# 		# //load
# 		$.getJSON('/sprites/sprites.json')
# 		$.getJSON('/levels/levels.json')
# 	).then(
# 		# //game
# 		(sprites, levels) ->
# 			songs = levels[0]

# 			canvas = $('#tugtog')[0]

# 			settings.cX = $('#tugtog').position().left
# 			settings.cY = $('#tugtog').position().top

# 			game := new Game(canvas, songs, sprites[0])
# 			game.init()
			
# 			angular.element(document).ready ->
# 				angular.bootstrap(document)
# 	)

app = angular.module('tugtog', [])

# app.directive('game', ->
# 	{
# 		restrict: 'E',
# 		template: '<canvas id="test"></canvas>'
# 	}
# )

app.controller('Main', ($scope, $http, $q) ->
	$scope.game = {}
	$scope.spriteReq = $http.get('/sprites/sprites.json')
	$scope.levelReq = $http.get('/levels/levels.json')

	$q.all([$scope.spriteReq, $scope.levelReq]).then((values)->
		$scope.sprites = values.0.data
		$scope.levels = values.1.data

		canvas = $('#tugtog')[0]

		$scope.game = new Game(canvas, $scope.levels, $scope.sprites)
		$scope.game.init!
	)

	$scope.playSong = (level) ->
		$scope.game.level = new Level(level)
		$(document).on('keydown', @keydown)
		$(document).on('keyup', @keyup)
		$scope.game.start!
)