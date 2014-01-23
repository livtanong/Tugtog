# game = {}
themes =
  * "name": "beach"
    "bg": "beach.png"
    "note": "Crab Note.png"
    "menu": "beach-menu.png"
  * "name": "bukid"
    "bg": "bukid.png"
    "note": "Rice Note.png"
    "menu": "bukid-menu.png"
  * "name": "barrio"
    "bg": "barrio.png"
    "note": "Chick Note.png"
    "menu": "barrio-menu.png"

state = {}

animations = 
  "hitting":
    '1.png'
    '3.png'
    '2.png'
    '1.png'

app = angular.module('tugtog', [])

app.controller('Main', ($scope, $http, $q) ->
  $scope.current = 'levels'
  $scope.currentLevel = 0
  $scope.game = {}
  $scope.themes = themes
  $scope.score = 0
  $scope.spriteReq = $http.get('/sprites/sprites.json')
  $scope.levelReq = $http.get('/levels/levels.json')

  $q.all([$scope.spriteReq, $scope.levelReq]).then((values)->
    $scope.sprites = values.0.data
    $scope.levels = values.1.data

    canvas = $('#tugtog')[0]

    $scope.game = new Game(canvas, $scope.levels, $scope.sprites, $scope)
  )

  $scope.getTheme = (theme) ->
    # console.log $scope.themes |> find ((x) -> x.name is theme)
    $scope.themes |> find ((x) -> x.name is theme)

  $scope.next = ->
    if $scope.currentLevel < $scope.levels.length - 1
      $scope.currentLevel += 1

  $scope.back = ->
    if $scope.currentLevel > 0
      $scope.currentLevel -= 1

  $scope.keydown = (e) ~>
    lane = $scope.game.level?.lanes[settings.keys[e.which]]
    if lane
      lane.opacity = 0.8
      # console.log($scope.game.notesToRender |> filter((note) -> note.lane.key is lane.key))

      candidate = $scope.game.notesToRender
        |> filter (.lane.key is lane.key)
        |> map ((note) -> $scope.game.level.gradeNote(note); note)
        |> sort-by (-> Math.abs(it.diff))
        |> head

      if candidate?.isActive and $scope.game.level.gradeNote(candidate) isnt "ignored"
        $scope.game.triggerNote(candidate, lane)

  $scope.keyup = (e) ~>
    lane = $scope.game.level?.lanes[settings.keys[e.which]]
    if lane
      lane.opacity = 0

  $scope.playSong = (level) ->
    $scope.game.init!
    $scope.current = 'game'
    $scope.game.level = new Level(level)
    $scope.game.start!
    state.isDone = false

  $scope.endSong = ->
    $scope.current = 'levels'
    $scope.game.level = {}
    $scope.game.reset!
)