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

	percentAge: ->
		(@lifespan - @age) / @lifespan

	animUpdate: ->
		@age += state.delta
		@y -= @speed * state.delta
		@speed -= 1

		console.log @age
		@

	reset: ->
		@x = @target.x
		@y = @target.y
		@age = 0
		@speed = 40

	draw: (ctx) ->
		ctx.fillStyle = "white"
		ctx.textAlign = "left"
		ctx.textBaseline = "top"
		ctx.font = "24px 'Helvetica Neue'"
		ctx.fillText(@message, @x, @y - 20)