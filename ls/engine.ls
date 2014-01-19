game = {}
themes =
	"beach":
		"bg": "Beach.png"
		"note": "Crab Note.png"
	"rice":
		"bg": "Rice Field.png"
		"note": "Rice Note.png"

$ -> 
	$.when(
		# //load
		$.getJSON('/sprites/sprites.json')
		$.getJSON('/levels/levels.json')
	).then(
		# //game
		(sprites, levels) ->
			songs = levels[0]

			canvas = $('#tugtog')[0]

			settings.cX = $('#tugtog').position().left
			settings.cY = $('#tugtog').position().top

			game := new Game(canvas, songs, sprites[0])
			game.init()
			
			angular.element(document).ready ->
				angular.bootstrap(document)
	)