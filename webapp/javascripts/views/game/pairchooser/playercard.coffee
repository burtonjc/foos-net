define [
  'jquery'
  'jqueryui'
  'underscore'
  'marionette'
  'models/player'
  'cryptojs'
  'views/game/pairchooser/playerrecord'
  'tpl!templates/game/pairchooser/playercard.html'

], ($, jqueryui, _, Marionette, Player, CryptoJS, PlayerRecordView, PlayerCardTpl) ->

  Marionette.Layout.extend
    template: PlayerCardTpl
    className: 'player-card img-rounded'
    tagName: 'div'
    model: Player

    regions:
      playerRecord: '.player-record-region'

    triggers:
      'drag:dropped': 'drag:dropped'

    initialize: (opts) ->
      this.templateHelpers =
        imgSize: opts.imgSize || 30
        emailHash: CryptoJS.MD5(this.model.get('email').trim().toLowerCase())

    onRender: () ->
      @playerRecord.show new PlayerRecordView(player: @model)
      $(@el).draggable(revert: 'invalid')
