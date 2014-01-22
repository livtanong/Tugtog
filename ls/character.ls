class Character
	(@x, @y) ->
		@pulse!
		@state = 'relaxed'
		@frame = '1.png'

	pulseMag: 10px
	hitDur: 0.2s
	lastPulse: 0

	hit: ->
		@state = 'hitting'
		@animIndex = 0
		@animTime = 0

	pulse: ->
		@headY = @y + @pulseMag + 4

	animUpdate: ->
		speed = @pulseMag/1000
		if @state is 'hitting' and @animIndex < animations.hitting.length
			@frame = animations.hitting[@animIndex]
			@animIndex += 1
			# @animTime += state.delta
			# if @animTime >= 1/60
			# 	@animIndex += 1
			# 	@animTime = 0

		if !state.isDone
			@headY = @headY - speed * state.delta * 1000
	
	draw: (ctx, sdata) ->
		sHead = sdata.frames['drummer/head.png'].frame
		s = sdata.frames["drummer/#{@frame}"].frame
		# centerize
		x = @x - s.w / 2

		ctx.drawImage(sprites, s.x, s.y - 10, s.w, s.h, x, @y, s.w, s.h)
		ctx.drawImage(sprites, sHead.x, sHead.y, sHead.w, sHead.h, x, @headY, sHead.w, sHead.h)