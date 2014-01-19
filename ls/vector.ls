class Point
	(@x, @y) ->

class Vector
	(@x, @y) ->

	mag: -> (@x ^ 2 + @y ^ 2) ^ 0.5
	unit: -> new Vector(@x / @mag!, @y / @mag!)
	add: (vector) -> new Vector(@x + vector.x, @y + vector.y)
	dot: (vector) -> @x * vector.x + @y * vector.y
	norm: -> new Vector(-@y, @x)
	neg: -> new Vector(-1 * @x, -1 * @y)
	draw: (ctx) ->
		ctx.beginPath!
		ctx.arc(@x, @y, 10, 0, Math.PI * 2, false)
		ctx.closePath!

		ctx.fillStyle = 'red'
		ctx.fill!

class ImplicitLine
	(@point1, @point2) ->

		@d = new Vector(@point2.x - @point1.x, @point2.y - @point1.y)
		@v = @d.unit!
		@vn = @v.norm!

	pointFromIntersectionWith: (line) ->
		a = @point1.x * @point2.y - @point1.y * @point2.x
		x3x4 = line.point1.x - line.point2.x
		b = line.point1.x * line.point2.y - line.point1.y * line.point2.x
		x1x2 = @point1.x - @point2.x

		y3y4 = line.point1.y - line.point2.y
		y1y2 = @point1.y - @point2.y

		c = x1x2 * y3y4 - y1y2 * x3x4

		x = (a * x3x4 - b * x1x2)/c
		y = (a * y3y4 - b * y1y2)/c
		new Vector(x, y)

	err: (x, y) ->
		a = @vn.x
		b = @vn.y
		c = - (a * @point1.x) - (b * @point1.y)

		a * x + b * y + c

	errWithPoint: (point) ->
		@err(point.x, point.y)

	findValWithAxis: (axis, val) ->
		a = @vn.x
		b = @vn.y
		c = - (a * @point1.x) - (b * @point1.y)

		if axis is 'y'
			(( -b * val ) - c ) / a
		else
			(-a * val - c) / b

	findY: (x) -> @findValWithAxis('x', x)

	findX: (y) -> @findValWithAxis('y', y)

	majorAxis: ->
		if abs(@v.y) > abs(@v.x) then 'y' else 'x'

	createPointWithAxis: (majorAxis, val) ->
		if majorAxis is 'x' then minorAxis = 'y' else minorAxis = 'x'
		"#majorAxis": val
		"#minorAxis": Math.round(@findValWithAxis(majorAxis, val) * 100) / 100

	intPointsContainingPoint: (point) ->

		if point.x % 1 is 0 and point.y % 1 is 0
			# just perfect, just return the point.
			[{x: point.x, y: point.y, factor: 1}]
		else if point.x % 1 is 0
			# concentrate on y
			ceil = Math.ceil(point.y)
			floo = Math.floor(point.y)
			[
				{
					x:point.x, 
					y:ceil, 
					factor: 1 - abs(@err(point.x, ceil))
				}
				{
					x:point.x
					y:floo
					factor: 1 - abs(@err(point.x, floo))
				}
			]
		else if point.y % 1 is 0
			# concentrate on x
			ceil = Math.ceil(point.x)
			floo = Math.floor(point.x)
			[
				{
					x:ceil
					y:point.y
					factor: 1 - abs(@err(ceil, point.y))
				}
				{
					x:floo
					y:point.y
					factor: 1 - abs(@err(floo, point.y))
				}
			]
		else
			console.log("neither axes are integers")

	rasterPoints: ->
		axis = @majorAxis!

		points = []
		sign = signum(@point2[axis] - @point1[axis])

		for i from @point1[axis] til @point2[axis] by sign
			_point = @createPointWithAxis(axis, i)

			for point in @intPointsContainingPoint(_point)
				points.push point

		points

	rasterPointsTo: ->
		axis = @majorAxis!

		points = []
		sign = signum(@point2[axis] - @point1[axis])

		for i from @point1[axis] to @point2[axis] by sign
			_point = @createPointWithAxis(axis, i)

			for point in @intPointsContainingPoint(_point)
				points.push point

		points