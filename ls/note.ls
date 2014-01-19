class Note
	(@key, @x, @w, @start, @end) ->
		@h = 20
		@y = @start
		@opacity = 1
		@isPlaying = true
		@isActive = true
		@deadline = 0
		@color = "blue"
		@speed = 0
		@diff = 0
		@grade = 0
		@deadlineBeat = game.currBeat.add game.level.measure
		@deadline = @deadlineBeat.toTime! + 0.17
		@lifespan = @deadlineBeat.add(new Beat(2))
		@length = @end - @start
		@birthday = game.level.audio.getTime!/* game.now*/

	age: ->
		(game.level.audio.getTime! - @birthday) / (@deadline - @birthday)

	setDiff: ->
		@diff = game.level.audio.getTime! - @deadline
		@grade = settings.grade(@diff)

	animUpdate: ->
		if @isPlaying
			@y = @age! * @length + @start
			@opacity -= 0.6 * game.delta * 1000 / game.level.beatDur

			if game.now > @lifespan.toTime()
				@isPlaying = false

	trigger: ->
		@isActive = false
		@color = "green"
		new Notif(@, "#{@grade}!, #{deci2(@diff)} s")
		game.score.add settings.score(@grade)

	pulse: ->
		@opacity = 1

	draw: (ctx, sdata) ->
		if @isPlaying

			ctx.globalAlpha = @opacity

			# ctx.fillStyle = @color
			# ctx.fillRect(@x, @y - @h / 2, @w, @h)
			# ctx.globalAlpha = 1

			note = sdata?.frames[themes[game.level.meta.theme].note]?.frame
			ctx.drawImage(sprites, note.x, note.y, note.w, note.h, @x, @y - @h/2, @w, @h)

			ctx.globalAlpha = 1

class PerspNote extends Note
	(@key, @rail1, @rail2, @start, @end, @ap) ->
		super ...

	animUpdate: ->
		if @isPlaying
			@y = game.level.ageToPersp(@age!)
			@x = @rail1.findX(@y)
			@w = @rail2.findX(@y) - @x
			@h = @w
			@opacity -= 0.6 * game.delta * 1000 / game.level.beatDur
			if game.level.audio.getTime! > @lifespan.toTime()
				@isPlaying = false
