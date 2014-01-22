class Character
	(@x, @y) ->
		@up!
		@pulse!
		@state = 'relaxed'
		@frame = '0.png'

	pulseMag: 10px
	hitDur: 0.2s
	lastPulse: 0

	hit: ->
		@state = 'hitting'
		@animStart = state.now
		@animIndex = 0
		@animTime = 0

	pulse: ->
		@headY = @y + @pulseMag + 4

	animUpdate: ->
		if @state is 'hitting' and @animIndex < animations.hitting.length
			@frame = animations.hitting[@animIndex]
			@animTime += state.delta
			if @animTime >= 1/24
				@animIndex += 1
				@animTime = 0
		speed = @pulseMag/1000
		@headY = @headY - speed * state.delta * 1000
	
	draw: (ctx, sdata) ->
		sHead = sdata.frames['drummer/head.png'].frame
		s = sdata.frames["drummer/#{@frame}"].frame
		# centerize
		x = @x - s.w / 2

		ctx.drawImage(sprites, s.x, s.y - 10, s.w, s.h, x, @y, s.w, s.h)
		ctx.drawImage(sprites, sHead.x, sHead.y, sHead.w, sHead.h, x, @headY, sHead.w, sHead.h)