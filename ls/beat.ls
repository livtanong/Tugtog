class Beat
	(@num) ->

	dur: (game) ->
		# returns ms
		# 60secondsperminute * 1000milliscondspersecond * @num / game.level.bpm
		60secondsperminute * @num / game.level.bpm

	toTime: (game) ->
		state.timeStartLevel + @dur(game)

	add: (beat) ->
		new Beat(@num + beat.num)

	inc: ->
		@num += 1
		@