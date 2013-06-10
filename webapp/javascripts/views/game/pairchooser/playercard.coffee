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

    templateHelpers:
      emailHash: ->
        CryptoJS.MD5(@email.trim().toLowerCase())
      hideElo: false
      imgSize: 77
      permanent: false
      slim: false
      stationary: false

    events:
      'click .remove' : ->
        @vent?.trigger 'player:remove', @model
        @trigger 'remove', @model
      'click .move'   : ->
        @vent?.trigger 'player:move', @model
        @trigger 'move', @model

    ui:
      removeIcon: '.remove'
      moveIcon  : '.move'

    regions:
      playerRecord: '.player-record-region'

    initialize: (opts={}) ->
      if opts.slim
        @$el.addClass 'slim'
      @vent = opts.vent
      for key, value of @templateHelpers
        @[key] = @templateHelpers[key] = opts[key] ? @templateHelpers[key]

    onRender: () ->
      unless @hideRatings
        @playerRecord.show new PlayerRecordView(player: @model)

      unless @permanent
        @ui.removeIcon.find('i').tooltip
          placement: 'left'
          title: 'Remove player...'
          trigger: 'manual'

        @ui.removeIcon.mouseenter () =>
          @ui.removeIcon.find('i').tooltip('show');
        @ui.removeIcon.mouseleave () =>
          @ui.removeIcon.find('i').tooltip('hide');

      unless @stationary
        @ui.moveIcon.find('i').tooltip
          placement: 'left'
          title: 'Move player to other pair...'
          trigger: 'manual'

        @ui.moveIcon.mouseenter () =>
          @ui.moveIcon.find('i').tooltip('show');
        @ui.moveIcon.mouseleave () =>
          @ui.moveIcon.find('i').tooltip('hide');
