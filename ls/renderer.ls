class Renderer
	(@canvas, @sdata) ->
		@ctx = @canvas.getContext('2d')

	drawFinishLine: ->
		@ctx.fillStyle = "white"
		@ctx.fillRect(0, settings.finishline, settings.screenW, 1)

	drawStartLine: ->
		@ctx.fillStyle = "white"
		@ctx.fillRect(0, settings.startline, settings.screenW, 1)

	drawChars: (chars) ->
		[char.draw(@ctx, @sdata) for char in chars]

	drawUI: (ui) -> 
		[elem.draw(@ctx) for elem in ui]
		for elem in ui
			elem.draw(@ctx)

	
			
	redraw: (game) ->
		innerRedraw = ~>
			@clearCanvas()

			if game.hasLevelStarted
				
				[lane.draw(@ctx) for , lane of game.level.lanes]
				[lane.char.draw(@ctx, @sdata) for , lane of game.level.lanes]
				[note.draw(@ctx, @sdata) for note in game.notesToRender]

				# @drawStartLine()
				@drawFinishLine()

				[notif.draw(@ctx, @sdata) for notif in game.notifs]

			@drawChars(game.chars)
			# @drawUI(game.ui)

		innerRedraw()

	clearCanvas: ->
		# @ctx.fillStyle = "transparent"
		# @ctx.fillRect(0, 0, @canvas.width, @canvas.height);

		@ctx.clearRect(0,0,@canvas.width,@canvas.height);