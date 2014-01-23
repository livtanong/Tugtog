class Notif
	(@target, @message) ->
		@x = @target.x
		@y = @target.y
		@lifespan = 2 #seconds
		@notifAge = 0
		@notifDelay = 0.25
		@animNotifs = []
		@age = 0 #seconds
		@speed = 80
		@scale = 0
		@opacity = 1

	percentAge: ->
		(@lifespan - @age) / @lifespan

	animUpdate: ->
		@age += state.delta
		maxScale = 1.1
		critAge = 0.5 - Math.asin(1 / maxScale) / (2 * Math.PI)
		if @age <= critAge
			@scale = 1.1 * Math.sin(@age * 2 * Math.PI)
			@opacity = 1
		else
			@scale = 1
			@opacity = (@lifespan - @age) / critAge
		# @scale = @age
		# @y -= @speed * state.delta
		# @speed -= 1

		# @

	reset: ->
		@x = @target.x
		@y = @target.y
		@age = 0
		@speed = 40

	draw: (ctx, sdata) ->
		b = sdata.frames["balloon.png"].frame
		ctx.globalAlpha = @opacity
		h = b.h * @scale * 0.5
		w = b.w * @scale * 0.5
		ctx.drawImage(sprites, b.x, b.y, b.w, b.h, @x - h/2, @y - w/2 + 20, w, h)
		# ctx.fillRect(@x - w/2, @y - h/2, w, h)

		ctx.fillStyle = "brown"
		ctx.textAlign = "center"
		ctx.textBaseline = "top"
		ctx.font = "24px 'Action Man'"
		ctx.fillText(@message, @x, @y - 10)
		ctx.globalAlpha = 1