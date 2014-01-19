class Beat
	(@num) ->

	dur: ->
		# returns ms
		# 60secondsperminute * 1000milliscondspersecond * @num / game.level.bpm
		60secondsperminute * @num / game.level.bpm

	toTime: ->
		game.timeStartLevel + @dur!

	add: (beat) ->
		new Beat(@num + beat.num)

	inc: ->
		@num += 1
		@