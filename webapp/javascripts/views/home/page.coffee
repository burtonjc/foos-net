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

    events:
      'click .start-game': 'onStartGameClick'

    onStartGameClick: ->
      require [
        'controllers/game'
      ], (GameController) ->
        new GameController(region: FoosNet.modal)
