define [
  'underscore'
  'jquery'
  'bootstrap'
  'marionette'
  'tpl!templates/home/page.html'

], (_, $, Bootstrap, Marionette, HomePageTpl) ->
  
  Marionette.ItemView.extend
    className: 'home-page'
    template: HomePageTpl

    events:
      'click .start-game': 'onStartGameClick'

    onStartGameClick: () ->
      require [
        'foosnet'
        'controllers/game'
      ], (FoosNet, GameController) ->
        new GameController({
          region: FoosNet.modal
        }).playGame()
