define [
  'jquery'
  'underscore'
  'backbone'
  'marionette'
  'models/player'
  'collections/players'
  'views/game/pairchooser/pairchooser'
  'tpl!templates/game/playerchooser.html'

], ($, _, Backbone, Marionette, Player, PlayersCollection, PairChooser, PlayerChooserTpl) ->

  Marionette.Layout.extend
    template: PlayerChooserTpl

    ui:
      newPlayerIcon: '.new-player'
      playerTypeAhead: 'input.players-typeahead'
      
    regions:
      pairChooserRegion: '.pair-chooser'

    collectionEvents:
      'add': '_updateTypeAheadSource'
      'remove': '_updateTypeAheadSource'

    collection: new PlayersCollection()
    players: null
    pairChooser: null

    vent: _.extend {}, Backbone.Events

    initialize: (opts) ->
      _.bindAll @
      @vent.on 'ready', @_ready, @
      @vent.on 'notready', @_notready, @

      @vent.on 'player:remove', (player) ->
        @_setPlayerStaged player, false
      , @

    close: ->
      @vent.off()
      @ui.playerTypeAhead.typeahead().remove()
      @destroyRegions()

    onRender: ->
      @collection.reset()
      @pairChooser = new PairChooser
        collection: @collection
        vent: @vent
      @pairChooserRegion.show @pairChooser

      new PlayersCollection().fetch
        success: (collection, response, options) =>

          @players = collection

          @_initializeNewPlayerPopover()
          @_initializeTypeAhead()

    getPairs: () ->
      @pairChooser.getPairs()

    _initializeTypeAhead: () ->
      @ui.playerTypeAhead.typeahead
        updater: (playerName) =>
          @_setPlayerStaged @players.where(name: playerName)[0], true
          playerName

      .ready () =>
        setTimeout () => # i can't figure out a better way to wait for the animation
          @ui.playerTypeAhead.focus()
        , 600
      .keypress () =>
        @ui.newPlayerIcon.popover 'hide'

      @ui.newPlayerIcon.tooltip
        title: "Add new player"
        placement: 'right'
        selector: 'i'

      @_updateTypeAheadSource()

    _initializeNewPlayerPopover: () ->
      @ui.newPlayerIcon.popover
        placement: 'bottom'
        html: true
        title: '<h4>Create new player...</h4>'
      .on 'show', () =>
        val = @ui.playerTypeAhead.val()
        @ui.newPlayerIcon.data().popover.options.content = [
          '<div class="alert-placeholder"></div>',
          '<input class="new-player-name" type="text" placeholder="Name">',
          '<input class="new-player-email" type="text" placeholder="Email (used for Gravatar)">',
          '<button class="btn pull-left btn-cancel" aria-hidden="true">Cancel</button>',
          '<button class="btn btn-primary pull-right btn-create">Create</button>'
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

          error: (model, xhr, options) ->
            @ui.newPlayerIcon.popover 'hide'
            @trigger('error', 'There is already a player named ' + val)

    _setPlayerStaged: (player, staged) ->
      player = this.players.get player

      if staged
        @collection.add player
        setTimeout(() =>
          @ui.playerTypeAhead.val ''
        , 10)
      else
        @collection.remove player

    _updateTypeAheadSource: () ->
      updatedSource = _.chain(@players.models)
                .difference(@collection.models)
                .pluck('attributes')
                .pluck("name")
                .value()

      @ui.playerTypeAhead.typeahead().data('typeahead').source = updatedSource

    _ready: () ->
      @ui.playerTypeAhead.attr 'disabled', 'disabled'
      @ui.newPlayerIcon.attr 'disabled', 'disabled'
      @ui.newPlayerIcon.removeClass 'pointer'
      @trigger 'ready'

    _notready: () ->
      @ui.playerTypeAhead.removeAttr 'disabled'
      @ui.newPlayerIcon.removeAttr 'disabled'
      @ui.newPlayerIcon.addClass 'pointer'
      @trigger 'notready'
