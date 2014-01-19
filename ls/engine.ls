game = {}
$ -> 
	$.when(
		# //load
		$.getJSON('/sprites/sprites.json')
		$.getJSON('/levels/1.json')
		$.getJSON('/levels/2.json')
		$.getJSON('/levels/3.json')
	).then(
		# //game
		(sprites, ttl1, ttl2, ttl3) ->
			songs = [ttl1[0], ttl2[0], ttl3[0]]

			canvas = $('#tugtog')[0]

			settings.cX = $('#tugtog').position().left
			settings.cY = $('#tugtog').position().top

			game := new Game(canvas, songs, sprites[0])
			game.init()
			
			angular.element(document).ready ->
				angular.bootstrap(document)
	)