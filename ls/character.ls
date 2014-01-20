class Character
	(@x, @y) ->
		@up!
		@pulse!

	pulseMag: 10px
	hitDur: 0.2s
	isHitting: false
	lastPulse: 0

	down: -> @state = "down"
	up: -> @state = "up"

	hit: ->
		@down!
		@isHitting = true

	pulse: ->
		@headY = @y + @pulseMag

	animUpdate: ->
		if @isHitting and game.level.audio.getTime! > @lastPulse + @hitDur
			@up!
		speed = @pulseMag/game.level.beatDur
		@headY = @headY - speed * game.delta * 1000
	
	draw: (ctx, sdata) ->
		sUp = sdata.frames['raised.png'].frame
		sDown = sdata.frames['lowered.png'].frame
		sHead = sdata.frames['head.png'].frame

		if @state is "down" then s = sDown else s = sUp

		# centerize
		x = @x - s.w / 2

		ctx.drawImage(sprites, s.x, s.y - 10, s.w, s.h, x, @y, s.w, s.h)
		ctx.drawImage(sprites, sHead.x, sHead.y, sHead.w, sHead.h, x, @headY, sHead.w, sHead.h)