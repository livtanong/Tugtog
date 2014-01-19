class LinearLayout
	(@elems, @x, @y, @spacing, @orientation='vertical') ->
		# elems is an array
		# orientation is a string, expect vertical, horizontal

		switch @orientation
		case 'vertical'
			ints = [@y to @y + @spacing * @elems.length by @spacing]
			elemPair = zip @elems, ints

			for elem in elemPair
				elem[0].y = elem[1] 
				elem[0].x = @x

		case 'horizontal'
			ints = [@x to @x + spacing * @elems.length by @spacing]
			elemPair = zip @elems, ints

			for elem in elemPair
				elem[0].y = @y
				elem[0].x = elem[1]


class Button
	->

class TextButton extends Button
	(@text, @x, @y, @callback, @arg=null) ->

	isEventWithinBounds: (event, ctx) ->

		metrics = ctx.measureText(@text)
		width = metrics.width

		x = @x + settings.cX
		y = @y + settings.cY

		x <= event.clientX <= width + x and 
		y <= event.clientY <= 18 + y

		# 18px is due to font size.

	draw: (ctx) ->
		ctx.fillStyle = "white"
		ctx.textAlign = "left"
		ctx.textBaseline = "top"
		ctx.font = "24px 'Action Man'"

		ctx.fillText(@text, @x, @y)

class ImageButton extends Button
	(@sprite, @x, @y, @callback, @arg=null) ->

	isEventWithinBounds: (event, ctx) ->
		x = @x + settings.cX
		y = @y + settings.cY

		x <= event.clientX <= @sprite.width + x and 
		y <= event.clientY <= @sprite.height + y

	draw: (ctx) ->
		ctx.drawImage(@sprite, @x, @y)