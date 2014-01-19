class Lane
	(@key, @x, @w) ->
		@y = 0
		@h = settings.screenH
		@opacity = 0
		@start = settings.startline
		@end = settings.finishline
		@char = new Character(@x, settings.startline - 128)

	noteProto: ->
		new Note(@key, @x, @w, @start, @end)

	draw: (ctx) ->
		ctx.strokeStyle = "gray"
		ctx.strokeRect(@x, @y, @w, @h)
		
		# highlight
		ctx.globalAlpha = @opacity
		ctx.fillStyle = "white"
		ctx.fillRect(@x, @y, @w, @h)

		ctx.globalAlpha = 1

class PerspLane extends Lane
	(@key, @x, @w, @vp, @ap) ->
		super ...
		@l1 = new ImplicitLine(new Vector(@x, @end), @vp)
		@l2 = new ImplicitLine(new Vector(@x + @w, @end), @vp)
		@x1 = @l1.findX(@start)
		@x2 = @l2.findX(@start)
		@x1e = @l1.findX(@end)
		@x2e = @l2.findX(@end)
		@char = new Character((@x1 + @x2)/2, settings.startline - 128)

	noteProto: ->
		new PerspNote(@key, @l1, @l2, @start, @end, @ap)
		
	draw: (ctx) ->
		ctx.beginPath!
		ctx.moveTo(@x1e, @end)
		# ctx.lineTo(@vp.x, @vp.y)
		ctx.lineTo(@x1, @start)
		ctx.lineTo(@x2, @start)
		ctx.lineTo(@x2e, @end)
		ctx.lineTo(@x1e, @end)

		# ctx.strokeStyle = 'gray'
		# ctx.stroke!

		ctx.globalAlpha = @opacity
		ctx.fillStyle = 'white'
		ctx.fill!
		ctx.globalAlpha = 1