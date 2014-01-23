{minimum, head, find, sort-by, flatten, filter, map, reject, each, fold, zip, min, max} = require 'prelude-ls'

settings =
	screenW: 960
	screenH: 640
	laneW: 960 / 9
	margin: 960 / 9
	startline: 342
	finishline: 612
	speed: 50

	keys:
		83: 's'
		68: 'd'
		70: 'f'
		32: 'space'
		74: 'j'
		75: 'k'
		76: 'l'

	grade: (t) ->
		when -0.100 <= t <= 0.100
			"great"
		when 0.100 < t <= 0.200 or -0.100 > t >= -0.200
			"good"
		when -0.200 > t >= -0.500 or 0.200 < t <= 0.500
			"bad"
		when t > 0.500 or t < -0.500
			"ignored"

	score: (grade) ->
		when grade is "great"
			150
		when grade is "good"
			50
		when grade is "bad"
			-100
		else
			0

sprites = new Image()
sprites.src = "/sprites/sprites.png"

# class SpriteDict
# 	->
# 		@playGame = new Image()
# 		@playGame.src = 'images/sariscan.png'
# 		@song1 = new Image()
# 		@song1.src = 'images/sariload.png'
# sprites = new SpriteDict

ui =
	buttons:
		# playGame: new Button(sprites.playGame, 0, 0, 'songList')
		song1: new TextButton("Hold Me Steady", 144, 144, 'playSong')

