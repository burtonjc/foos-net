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
      'click .start-game': 'onStartGameClick'
      'click .create-league': 'onCreateLeagueClick'
      'click .join-league': 'onJoinLeagueClick'

    onStartGameClick: ->
      require [
        'controllers/game'
      ], (GameController) ->
        new GameController(region: FoosNet.modal)

    onCreateLeagueClick: ->
      require [
        'controllers/league/create'
      ], (CreateLeagueController) ->
        new CreateLeagueController(region: FoosNet.modal)

    onJoinLeagueClick: ->
      require [
        'controllers/league/join'
      ], (JoinLeagueController) ->
        new JoinLeagueController(region: FoosNet.modal)
