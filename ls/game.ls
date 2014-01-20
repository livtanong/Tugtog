class Game
	(@canvas, @songs, @sdata) ->
		@renderer = new Renderer(@canvas, @sdata)
		@ctx = @canvas.getContext('2d')
		@score = 0

	notifs: []
	ui: []
	chars: []
	notesToRender: []
	highlightedLane: ''
	hasLevelStarted: false
	haveNotesComeOut: false
	state: 'mainmenu'

	requestAnimationFrame =
		window.requestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		window.mozRequestAnimationFrame ||
		window.msRequestAnimationFrame ||
		window.oRequestAnimationFrame ||
		(callback) -> setTimeout(callback, 1)
	

	start: ->
		@hasLevelStarted = true
		@level.audio.play!
		@timeStartAudio = Date.now!
		state.timeStartLevel = @level.audio.getTime! + @level.leadTime / 1000

	startLevel: ->
		state.currBeat = 0
		@haveNotesComeOut = true

	cleanNotifs: ->
		@notifs = @notifs.filter (notif) -> notif.age <= notif.lifespan

	cleanNotes: ->
		@notesToRender = @notesToRender |> filter (.isPlaying)

	triggerNote: (note) ->
		note.isActive = false
		# note.color = "green"
		new Notif(@, "#{@grade}!, #{deci2(@diff)} s")

		@score += settings.score(note.grade)
		console.log @score

	update: ~>
		# menu stuff

		# only execute when level has started
		if @hasLevelStarted

			# level is about to begin.
			if @level.audio.getTime! >= state.timeStartLevel and !@haveNotesComeOut
				@startLevel!

			# level is underway
			if @haveNotesComeOut

				# this is a beat.
				if @level.audio.getTime! >= @level.beatToTime(state.currBeat)
					# console.log @currBeat.toTime!, (@now - game.timeStartLevel)/60, @level.audio.getTime!
					
					notes = @level.sheet.shift! ? []
					# [@level.lanes[note]?.fire! for note in notes]
					for note in notes
						lane = @level.lanes[note]
						if lane
							lane.char.hit!
							@notesToRender.push(@level.spawnNote(lane))
					[note.pulse! for note in @notesToRender]
					[lane.char.pulse! for , lane of @level.lanes]

					state.currBeat += 1

				[@level.updateNote(note) for note in @notesToRender]
				[notif.animUpdate! for notif in @notifs]
				# [lane.char.animUpdate! for , lane of @level.lanes]

			@cleanNotifs()
			@cleanNotes()

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

