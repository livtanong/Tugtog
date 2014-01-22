class Game
	(@canvas, @songs, @sdata, @scope) ->
		@renderer = new Renderer(@canvas, @sdata)
		@ctx = @canvas.getContext('2d')
		@reset!

	highlightedLane: ''

	requestAnimationFrame =
		window.requestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		window.mozRequestAnimationFrame ||
		window.msRequestAnimationFrame ||
		window.oRequestAnimationFrame ||
		(callback) -> setTimeout(callback, 1)

	reset: ->
		@score = 0
		@hasLevelStarted = false
		@hasLevelEnded = false
		@haveNotesComeOut = false
		state.currBeat = 0
		@notifs = []
		@chars = []
		@notesToRender = []

	
	start: ->
		@hasLevelStarted = true
		@level.audio.play!
		@timeStartAudio = Date.now!
		state.timeStartLevel = @level.audio.getTime! + @level.leadTime / 1000

	end: ->
		@hasLevelEnded = true

	startLevel: ->
		state.currBeat = 0
		@haveNotesComeOut = true

	cleanNotifs: ->
		@notifs = @notifs.filter (notif) -> notif.age <= notif.lifespan

	cleanNotes: ->
		@notesToRender = @notesToRender |> filter (.isPlaying)

	triggerNote: (note) ->
		note.isActive = false
		@notifs.push(new Notif(note, "#{note.grade}!, #{deci2(note.diff)} s"))

		@score += settings.score(note.grade)

	update: ~>
		# menu stuff

		# only execute when level has started
		if @hasLevelStarted

			# level is about to begin.
			if @level.audio.getTime! >= state.timeStartLevel and !@haveNotesComeOut
				@startLevel!

			# level is underway
			if @haveNotesComeOut
				# n ms before a beat
				if @level.audio.getTime! >= @level.beatToTime(state.currBeat) - 4/24
					for note in @level.sheet |> head
						lane = @level.lanes[note]
						# if lane
						# 	lane.char.hit!
				# this is a beat.
				if @level.audio.getTime! >= @level.beatToTime(state.currBeat)
					# console.log @currBeat.toTime!, (@now - game.timeStartLevel)/60, @level.audio.getTime!
					
					notes = @level.sheet.shift! ? []
					# [@level.lanes[note]?.fire! for note in notes]
					for note in notes
						lane = @level.lanes[note]
						if lane
							@notesToRender.push(@level.spawnNote(lane))
							lane.char.hit!
					[note.pulse! for note in @notesToRender]
					[lane.char.pulse! for , lane of @level.lanes]

					state.currBeat += 1

				[@level.updateNote(note) for note in @notesToRender]
				[notif.animUpdate! for notif in @notifs]
				[lane.char.animUpdate! for , lane of @level.lanes]

			@cleanNotifs()
			@cleanNotes()

			if @level.audio.getPercent! >= 100
				@end!
				state.isDone = true
				@scope.$apply!

	frame: ~>
		@setDelta!
		@renderer.redraw(@)
		@update!
		requestAnimationFrame(@frame)

	setDelta: ->
		state.now = Date.now!
		state.delta = (state.now - state.then) / 1000
		state.then = state.now

	init: ->
		@setDelta!
		@frame!

