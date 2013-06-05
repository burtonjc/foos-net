define [
  'underscore'
  'jquery'
  'bootstrap'
  'marionette'
  'foosnet'
  'tpl!templates/home/page.html'

], (_, $, Bootstrap, Marionette, FoosNet, HomePageTpl) ->
  
  Marionette.ItemView.extend
    className: 'home-page'
    template: HomePageTpl

    ui:
      joinLeagueBtn: '.join-league.btn'

    events:
      'click .create-player': 'onCreatePlayerClick'
      'click .join-league'  : 'onJoinLeagueClick'
      'click .create-league': 'onCreateLeagueClick'
      'click .record-game'  : 'onRecordGameClick'

    onCreatePlayerClick: ->
      @_useController 'controllers/player/create'

    onJoinLeagueClick: ->
      @_useController 'controllers/league/join'

    onCreateLeagueClick: ->
      @_useController 'controllers/league/create'

    onRecordGameClick: ->
      @_useController 'controllers/game/create'

    _useController: (controllerName) ->
      require [controllerName], (controller) -> new controller
