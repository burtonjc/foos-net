define [
  'jquery'
  'jqueryui'
  'underscore'
  'marionette'
  'models/player'
  'cryptojs'
  'tpl!templates/game/pairchooser/playercard.html'

], ($, jqueryui, _, Marionette, Player, CryptoJS, PlayerCardTpl) ->

  Marionette.ItemView.extend
    template: PlayerCardTpl
    className: 'player-card img-rounded'
    tagName: 'div'
    model: Player

    triggers:
      'drag:dropped': 'drag:dropped'

    initialize: (opts) ->
      this.templateHelpers =
        imgSize: opts.imgSize || 30
        emailHash: CryptoJS.MD5(this.model.get('email').trim().toLowerCase())

    onRender: () ->
      $(@el).draggable(revert: 'invalid')
