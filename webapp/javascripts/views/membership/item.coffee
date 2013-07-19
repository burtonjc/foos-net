define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'cryptojs'
  'views/membership/record'
  'tpl!templates/membership/item.html'

], ($, _, Backbone, DomainCache, CryptoJS, RecordView, MembershipItemTpl) ->

  Backbone.Marionette.Layout.extend
    template: MembershipItemTpl
    className: 'player-card img-rounded'
    tagName: 'div'
    model: DomainCache.getModel 'player'

    vent: null

    opts:
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
        
      @templateHelpers ?= {
        emailHash: =>
          CryptoJS.MD5 @model.get('player').get('email').trim().toLowerCase()
        name: =>
          @model.get('player').get('name')
      }

      for key, value of @opts
        @[key] = @templateHelpers[key] = opts[key] ? @opts[key]

    onClose: ->
      @templateHelpers = @opts

    onRender: () ->
      unless @hideRatings
        @playerRecord.show new RecordView(model: @model)

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
