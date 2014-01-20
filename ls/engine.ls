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
	$scope.current = 'levels'
	$scope.game = {}
	$scope.score = 0
	$scope.spriteReq = $http.get('/sprites/sprites.json')
	$scope.levelReq = $http.get('/levels/levels.json')

	$q.all([$scope.spriteReq, $scope.levelReq]).then((values)->
		$scope.sprites = values.0.data
		$scope.levels = values.1.data

		canvas = $('#tugtog')[0]

		$scope.game = new Game(canvas, $scope.levels, $scope.sprites)
		$scope.game.init!
	)

	# $scope.$watch('game', ->
	# 	$scope.score = $scope.game.score
	# )

	$scope.keydown = (e) ~>
		console.log "hello?"
		lane = $scope.game.level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0.8
			# console.log($scope.game.notesToRender |> filter((note) -> note.lane.key is lane.key))

			candidate = $scope.game.notesToRender
				|> filter (.lane.key is lane.key)
				|> map ((note) -> $scope.game.level.gradeNote(note); note)
				|> sort-by (-> Math.abs(it.diff))
				|> head

			# console.log $scope.game.notesToRender |> map (.lane.key)
			if candidate?.isActive and $scope.game.level.gradeNote(candidate) isnt "ignored"
				$scope.game.triggerNote(candidate)

	$scope.keyup = (e) ~>
		lane = $scope.game.level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0

	$scope.playSong = (level) ->
		$scope.current = 'game'
		$scope.game.level = new Level(level)
		# $(document).on('keydown', $scope.keydown)
		# $(document).on('keyup', $scope.keyup)
		$scope.game.start!
)