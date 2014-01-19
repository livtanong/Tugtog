class Score
	->
	score: 0

	add: (points) ->
		@score += points

	draw: (ctx) -> 
		ctx.fillStyle = "white"
		ctx.textAlign = "center"
		ctx.textBaseline = "top"
		ctx.font = "48px 'Action Man'"
		ctx.fillText(@score, 960/2, 20)