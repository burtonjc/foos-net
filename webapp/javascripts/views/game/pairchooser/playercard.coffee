define [
  'jquery'
  'underscore'
  'marionette'
  'models/player'
  'cryptojs'
  'views/game/pairchooser/playerrecord'
  'tpl!templates/game/pairchooser/playercard.html'

], ($, _, Marionette, Player, CryptoJS, PlayerRecordView, PlayerCardTpl) ->

  Marionette.Layout.extend
    template: PlayerCardTpl
    className: 'player-card img-rounded'
    tagName: 'div'
    model: Player

    vent: null

    events:
      'click .remove' : ->
        @vent.trigger 'player:remove', @model
      'click .move'   : ->
        @vent.trigger 'player:move', @model

    ui:
      removeIcon: '.remove'
      moveIcon  : '.move'

    regions:
      playerRecord: '.player-record-region'

    initialize: (opts) ->
      @vent = opts.vent
      @templateHelpers =
        imgSize: opts.imgSize || 77
        emailHash: CryptoJS.MD5(this.model.get('email').trim().toLowerCase())

    onRender: () ->
      @playerRecord.show new PlayerRecordView(player: @model)

      @ui.removeIcon.find('i').tooltip
        placement: 'left'
        title: 'Remove player from match...'
        trigger: 'manual'

      @ui.removeIcon.mouseenter () =>
        @ui.removeIcon.find('i').tooltip('show');
      @ui.removeIcon.mouseleave () =>
        @ui.removeIcon.find('i').tooltip('hide');

      @ui.moveIcon.find('i').tooltip
        placement: 'left'
        title: 'Move player to other pair...'
        trigger: 'manual'

      @ui.moveIcon.mouseenter () =>
        @ui.moveIcon.find('i').tooltip('show');
      @ui.moveIcon.mouseleave () =>
        @ui.moveIcon.find('i').tooltip('hide');
