game = {}
$ -> 
	$.when(
		# //load
		$.getJSON('/sprites/sprites.json')
		$.getJSON('/levels/levels.json')
		# $.getJSON('/levels/2.json')
		# $.getJSON('/levels/3.json')
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