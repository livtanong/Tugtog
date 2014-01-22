class Character
	(@x, @y) ->
		@up!
		@pulse!
		@state = 'relaxed'
		@frame = '0.png'

	pulseMag: 10px
	hitDur: 0.2s
	lastPulse: 0

	down: -> @state = "down"
	up: -> @state = "up"

	hit: ->
		@state = 'hitting'
		@animStart = state.now
		@animIndex = 0

	pulse: ->
		@headY = @y + @pulseMag + 4

	animUpdate: ->
		if @state is 'hitting' and @animIndex < animations.hitting.length
			@frame = animations.hitting[@animIndex]
			console.log @frame
			@animIndex += 1
		# if @isHitting and game.level.audio.getTime! > @lastPulse + @hitDur
		# 	@up!
		speed = @pulseMag/1000
		@headY = @headY - speed * state.delta * 1000

	drumHit: ->
		@state = 'hitting'
		@animStart = state.now
		@animIndex = 0
	
	draw: (ctx, sdata) ->
		# sUp = sdata.frames['drummer/1.png'].frame
		# sDown = sdata.frames['drummer/3.png'].frame
		sHead = sdata.frames['drummer/head.png'].frame

		# if @state is "down" then s = sDown else s = sUp
		s = sdata.frames["drummer/#{@frame}"].frame
		# centerize
		x = @x - s.w / 2

		ctx.drawImage(sprites, s.x, s.y - 10, s.w, s.h, x, @y, s.w, s.h)
		ctx.drawImage(sprites, sHead.x, sHead.y, sHead.w, sHead.h, x, @headY, sHead.w, sHead.h)