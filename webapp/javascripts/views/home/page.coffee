define [
  'underscore'
  'jquery'
  'backbone.loader'
  'foosnet'
  'tpl!templates/home/page.html'

], (_, $, Backbone, FoosNet, HomePageTpl) ->
  
  Backbone.Marionette.ItemView.extend
    className: 'home-page'
    template: HomePageTpl

    events:
      'click .create-player': 'onCreatePlayerClick'
      'click .manage-league': 'onManageLeagueClick'
      'click .create-league': 'onCreateLeagueClick'
      'click .record-game'  : 'onRecordGameClick'

    onCreatePlayerClick: ->
      @_useController 'controllers/player/create'

    onManageLeagueClick: ->
      @_useController 'controllers/league/manage'

    onCreateLeagueClick: ->
      @_useController 'controllers/league/create'

    onRecordGameClick: ->
      @_useController 'controllers/game/create'

    _useController: (controllerName) ->
      require [controllerName], (controller) -> new controller
