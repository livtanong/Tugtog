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

	$scope.keydown = (e) ~>
		lane = $scope.game.level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0.8
			key = lane.key
			candidate = $scope.game.notesToRender
				|> filter (.key is key)
				|> map ((note) -> @level.gradeNote(note); note)
				|> sort-by (-> Math.abs(it.diff))
				|> head

			if candidate?.isActive and candidate.grade isnt "ignored" then candidate.trigger!

	$scope.keyup = (e) ~>
		lane = $scope.game.level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0

	$scope.playSong = (level) ->
		$scope.game.level = new Level(level)
		$(document).on('keydown', $scope.keydown)
		$(document).on('keyup', $scope.keyup)
		$scope.game.start!
)