class Level
	(@meta) ->
		@audio = new buzz.sound(@meta.src)
		@sheet = @meta.sheet
		@bpm = @meta.bpm
		@leadTime = @meta.leadTime
		@beatDur = 60secondsperminute * 1000milliscondspersecond / @bpm #ms
		@measure = new Beat(@meta.measure) #beats
		@vp = new Vector(settings.screenW/2, 0)

		@initPerspective!

		@lanes = 
			's': new PerspLane('s', settings.margin, settings.laneW, @vp, @ap)
			'd': new PerspLane('d', settings.margin + settings.laneW, settings.laneW, @vp, @ap)
			'f': new PerspLane('f', settings.margin + settings.laneW * 2, settings.laneW, @vp, @ap)
			'space': new PerspLane('space', settings.margin + settings.laneW * 3, settings.laneW, @vp, @ap)
			'j': new PerspLane('j', settings.margin + settings.laneW * 4, settings.laneW, @vp, @ap)
			'k': new PerspLane('k', settings.margin + settings.laneW * 5, settings.laneW, @vp, @ap)
			'l': new PerspLane('l', settings.margin + settings.laneW * 6, settings.laneW, @vp, @ap)

		@init(@)

	initPerspective: ->
		@bottomLeft = new Vector(settings.laneW, settings.finishline)
		@bottomRight = new Vector(settings.screenW - settings.laneW, settings.finishline)

		@l1 = new ImplicitLine(@bottomLeft, @vp)
		@l2 = new ImplicitLine(@bottomRight, @vp)

		@topLeft = new Vector(@l1.findX(settings.startline), settings.startline)
		@topRight = new Vector(@l2.findX(settings.startline), settings.startline)

		l3 = new ImplicitLine(@bottomRight, @topLeft)
		l4 = new ImplicitLine(@bottomLeft, @topRight)

		# @ap = new Vector(l3.findX(@vp.y), @vp.y)
		# given a line from the bottom left to the top right, 
		# return the coordinate where the line crosses the vanishing point line
		@ap = new Vector(l4.findX(@vp.y), @vp.y)

	ageToPersp: (age) ->
		p1 = new Vector(age * settings.laneW * 7 + settings.margin, settings.finishline)
		l = new ImplicitLine(p1, @ap)
		l.pointFromIntersectionWith(@l2).y

	draw: (ctx, sdata) ->
		# ctx.beginPath!
		# ctx.moveTo(@bottomLeft.x, @bottomLeft.y)
		# ctx.lineTo(@topLeft.x, @topLeft.y)
		# ctx.lineTo(@topRight.x, @topRight.y)
		# ctx.lineTo(@bottomRight.x, @bottomRight.y)
		# ctx.lineTo(@bottomLeft.x, @bottomLeft.y)
		bg = sdata.frames[@meta.bg].frame
		ctx.globalAlpha = 1
		ctx.drawImage(sprites, bg.x, bg.y, bg.w, bg.h, 0, 0, bg.w, bg.h)

		# ctx.strokeStyle = 'red'
		# ctx.stroke!

		# @ap.draw(ctx)
		# @apRight.draw(ctx)

	init: (level) ->
		@audio.load()
