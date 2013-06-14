define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'cryptojs'
  'views/game/pairchooser/playerrecord'
  'views/player/rating'
  'tpl!templates/game/pairchooser/playercard.html'

], ($, _, Backbone, DomainCache, CryptoJS, PlayerRecordView, PlayerRatingView, PlayerCardTpl) ->

  Backbone.Marionette.Layout.extend
    template: PlayerCardTpl
    className: 'player-card img-rounded'
    tagName: 'div'
    model: DomainCache.getModel 'player'

    vent: null

    opts:
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
      playerRating: '.player-rating-region'
      playerRecord: '.player-record-region'

    initialize: (opts={}) ->
      @vent = opts.vent
      if opts.slim
        @$el.addClass 'slim'
        
      @templateHelpers ?= {}

      for key, value of @opts
        @[key] = @templateHelpers[key] = opts[key] ? @opts[key]

      @league = opts.league

    onClose: ->
      @templateHelpers = @opts

    onRender: () ->
      unless @hideRatings
        @playerRecord.show new PlayerRecordView(player: @model)
      unless @hideElo
        @playerRating.show new PlayerRatingView(
          player: @model
          league: @league
          )

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
