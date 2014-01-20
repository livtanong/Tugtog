class PerspNote
	(@lane, @birthday, @deadline, @theme) ->
		@h = 20
		@y = @lane.start
		@opacity = 1
		@isPlaying = true
		@isActive = true
		@color = "blue"
		@speed = 0
		@diff = 0
		@grade = 0
		# @deadline = @deadlineBeat.toTime! + 0.17
		# @lifespan = @deadlineBeat + 2beats
		@length = @lane.end - @lane.start

	# trigger: (game) ->
	# 	@isActive = false
	# 	@color = "green"
	# 	new Notif(@, "#{@grade}!, #{deci2(@diff)} s")

	# 	# TODO: make game.score into not game.
	# 	state.score.add settings.score(@grade)

	pulse: ->
		@opacity = 1

	draw: (ctx, sdata) ->
		if @isPlaying

			ctx.globalAlpha = @opacity

			note = sdata?.frames[themes[@theme].note]?.frame
			ctx.drawImage(sprites, note.x, note.y, note.w, note.h, @x, @y - @h/2, @w, @h)

			ctx.globalAlpha = 1