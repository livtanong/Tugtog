class Game
	(@canvas, @songs, @sdata) ->
		@renderer = new Renderer(@canvas, @sdata)
		@ctx = @canvas.getContext('2d')

	notifs: []
	ui: []
	chars: []
	notesToRender: []
	score: new Score()
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
		@timeStartLevel = @level.audio.getTime! + @level.leadTime / 1000

	startLevel: ->
		@currBeat = new Beat(0)
		@haveNotesComeOut = true

	cleanNotifs: ->
		@notifs = @notifs.filter (notif) -> notif.age <= notif.lifespan

	cleanNotes: ->
		@notesToRender = @notesToRender |> filter (.isPlaying)

	update: ->
		# menu stuff

		# only execute when level has started
		if @hasLevelStarted

			# level is about to begin.
			if @level.audio.getTime! >= @timeStartLevel and !@haveNotesComeOut
				@startLevel!

			# level is underway
			if @haveNotesComeOut
				# console.log @level.audio.getTime!, @currBeat.toTime!

				# this is a beat.
				if @level.audio.getTime! >= @currBeat.toTime!
					# console.log @currBeat.toTime!, (@now - game.timeStartLevel)/60, @level.audio.getTime!
					
					notes = @level.sheet.shift! ? []
					# [@level.lanes[note]?.fire! for note in notes]
					for note in notes
						lane = @level.lanes[note]
						if lane
							lane.char.hit!
							@notesToRender.push(lane.noteProto!)
					[note.pulse! for note in @notesToRender]
					[lane.char.pulse! for , lane of @level.lanes]

					@currBeat.inc!
				# console.log @notesToRender
				[note.animUpdate! for note in @notesToRender]
				[notif.animUpdate! for notif in @notifs]
				[lane.char.animUpdate! for , lane of @level.lanes]

			@cleanNotifs()
			@cleanNotes()

	frame: ~>
		@setDelta!
		@renderer.redraw(@)
		@update!
		requestAnimationFrame(@frame)

	setDelta: ->
		@now = Date.now!
		@delta = (@now - @then) / 1000
		@then = @now

	keydown: (e) ~>
		# console.log 'hi'
		lane = @level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0.8
			key = lane.key
			candidate = @notesToRender
				|> filter (.key is key)
				|> map ((note) -> note.setDiff!; note)
				|> sort-by (-> Math.abs(it.diff))
				|> head

			if candidate?.isActive and candidate.grade isnt "ignored" then candidate.trigger!

	keyup: (e) ~>
		lane = @level.lanes[settings.keys[e.which]]
		if lane
			lane.opacity = 0

	MenuController: (e) ~>
		for elem in @ui
			if elem.isEventWithinBounds(e, @ctx)
				if elem.arg
					@[elem.callback](elem.arg)
				else 
					@[elem.callback]!

	mainMenu: ->
		@ui = [new TextButton("Play", 24, 24, 'songList', @songs)]

	songList: (songs) ->
		console.log "songlist!"
		buttonArr = [(new TextButton song.name, 0, 0, 'playSong', song) for song in songs]
		linearlayout = new LinearLayout(buttonArr, 24px, 24px, 48px, 'vertical')

		@ui = linearlayout.elems

	playSong: (song) ->
		@ui = []
		@level = new Level(song)
		$(document).on('keydown', @keydown)
		$(document).on('keyup', @keyup)

		@start()

	init: ->
		$(document).on('click', @MenuController)
		@setDelta!
		@frame!
		@mainMenu!

