define [
  'jquery'
  'underscore'
  'backbone'
  'marionette'
  'models/player'
  'collections/players'
  'views/ui/typeahead'
  'views/game/pairchooser/pairchooser'
  'tpl!templates/game/playerchooser.html'

], ($, _, Backbone, Marionette, Player, PlayersCollection, TypeAhead, PairChooser, PlayerChooserTpl) ->

  Marionette.Layout.extend
    template: PlayerChooserTpl

    ui:
      newPlayerIcon: '.new-player'
      
    regions:
      pairChooserRegion: '.pair-chooser'
      playerTypeAheadRegion: '.players-typeahead-region'

    collection: new PlayersCollection()
    pairChooser: null
    typeAhead: null

    vent: _.extend {}, Backbone.Events

    initialize: (opts) ->
      _.bindAll @

      @vent.on 'ready', @_ready, @
      @vent.on 'notready', @_notready, @
      @vent.on 'player:remove', (player) ->
        @_setPlayerStaged player, false
      , @

      @collection.reset()

      collection = new PlayersCollection()
      collection.fetch()
      @typeAhead = new TypeAhead
        collection: collection
        placeholder: 'Search for players...'

    onClose: ->
      @vent.off()
      @typeAhead.close

    onRender: ->
      @playerTypeAheadRegion.show @typeAhead

      @_initializeTypeAhead()
      @_initializeNewPlayerPopover()

      @pairChooser = new PairChooser
        collection: @collection
        vent: @vent
      @pairChooserRegion.show @pairChooser

    getPairs: () ->
      @pairChooser.getPairs()

    _initializeTypeAhead: () ->
      @typeAhead.$el.ready(() =>
        setTimeout () => # i can't figure out a better way to wait for the animation
          @typeAhead.focus()
        , 600
      ).focusin () =>
        @ui.newPlayerIcon.popover 'hide'

      @listenTo @typeAhead, 'model:selected', (model) =>
        @_setPlayerStaged model, true

    _initializeNewPlayerPopover: () ->
      @ui.newPlayerIcon.tooltip
        title: "Add new player"
        placement: 'right'
        selector: 'i'

      @ui.newPlayerIcon.popover
        placement: 'bottom'
        html: true
        title: '<h4>Create new player...</h4>'
      .on 'show', () =>
        val = @typeAhead.val()
        @ui.newPlayerIcon.data().popover.options.content = [
          "<div class=\"alert-placeholder\"></div>",
          "<input class=\"new-player-name\" type=\"text\" placeholder=\"Name\" value=\"#{val}\">",
          "<input class=\"new-player-email\" type=\"text\" placeholder=\"Email (used for Gravatar)\">",
          "<button class=\"btn pull-left btn-cancel\" aria-hidden=\"true\">Cancel</button>",
          "<button class=\"btn btn-primary pull-right btn-create\">Create</button>"
        ].join('')

      $(@el).delegate '.popover .btn-cancel', 'click',  () =>
        @ui.newPlayerIcon.popover 'hide'

      $(@el).delegate '.popover .btn-create', 'click',  () =>
        name = $('.new-player-name').val()
        email = $('.new-player-email').val()
        player = new Player()

        player.save {name: name, email: email},
          success: (model, response, options) =>
            @ui.newPlayerIcon.popover 'hide'
            @players.add model
            @_setPlayerStaged model, true

          error: (model, xhr, options) =>
            @ui.newPlayerIcon.popover 'hide'
            @trigger('error', 'There is already a player named ' + name)

    _setPlayerStaged: (player, staged) ->
      if staged
        unless @collection.contains player
          @collection.add player
          @typeAhead.remove player

        setTimeout(() =>
          @typeAhead.val ''
        , 10)
      else
        @collection.remove player
        @typeAhead.add player

    _ready: () ->
      @typeAhead.disable()
      @ui.newPlayerIcon.attr 'disabled', 'disabled'
      @ui.newPlayerIcon.removeClass 'pointer'
      @trigger 'ready'

    _notready: () ->
      @typeAhead.enable()
      @ui.newPlayerIcon.removeAttr 'disabled'
      @ui.newPlayerIcon.addClass 'pointer'
      @trigger 'notready'
