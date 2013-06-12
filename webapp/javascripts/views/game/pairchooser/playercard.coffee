define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'cryptojs'
  'views/game/pairchooser/playerrecord'
  'tpl!templates/game/pairchooser/playercard.html'

], ($, _, Backbone, DomainCache, CryptoJS, PlayerRecordView, PlayerCardTpl) ->

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
      playerRecord: '.player-record-region'

    initialize: (opts={}) ->
      @vent = opts.vent
      if opts.slim
        @$el.addClass 'slim'
        
      @templateHelpers ?=
        rating: -> _.findWhere(@memberships, league: opts.league.id)?.rating

      for key, value of @opts
        @[key] = @templateHelpers[key] = opts[key] ? @opts[key]

    onClose: ->
      @templateHelpers = @opts

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
