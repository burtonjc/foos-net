define [
  'jquery'
  'underscore'
  'marionette'
  'cryptojs'
  'models/player'
  'tpl!templates/game/playerlistrow.html'

], ($, _, Marionette, CryptoJS, Player, PlayerListRowTpl) ->
  
  Marionette.ItemView.extend
    template: PlayerListRowTpl
    model: Player
    tagName: 'tr'

    triggers:
      'click .icon-remove': 'removeclicked'

    initialize: (opts) ->
      @templateHelpers =
        imgSize: opts.imgSize || 60
        emailHash: CryptoJS.MD5 @model.get('email').trim().toLowerCase()
        hideX: opts.hideX || false
