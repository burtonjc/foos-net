define [
  'jquery'
  'underscore'
  'marionette'
  'models/player'
  'collections/players'
  'views/game/playerlistrow'
  'tpl!templates/game/playerchooser.html'

], ($, _, Marionette, Player, PlayersCollection, PlayerListRow, PlayerChooserTpl) ->

  Marionette.CompositeView.extend
    template: PlayerChooserTpl
    className: 'well'
    itemView: PlayerListRow
    itemViewContainer: 'tbody'

    collection: new PlayersCollection()

    ui:
      newPlayerIcon: '.new-player'
      playerTypeAhead: 'input.players-typeahead'
      stagedPlayerList: '.table tbody'

    collectionEvents:
      'add': '_updateTypeAheadSource'
      'remove': '_updateTypeAheadSource'

    initialize: (opts) ->
      _.bindAll @
      @on 'ready', @_ready
      @on 'notready', @_notready

    onRender: () ->
      new PlayersCollection().fetch
        success: (collection, response, options) =>
          @players = collection

          # In case we are reopening the dialog
          _.each @collection.models, (player) =>
            @players.where({_id: player.get('_id')})[0].set 'staged', true

          @_initializeNewPlayerPopover()
          @_initializeTypeAhead()

          @_updateTypeAheadSource()

      @on 'itemview:removeclicked', (view) =>
        player = view.model
        @_setPlayerStaged @collection.get(player.id), false
        @ui.playerTypeAhead.focus()

    _initializeTypeAhead: () ->
      @ui.playerTypeAhead.typeahead
        updater: (playerName) =>
          @_setPlayerStaged @players.where(name: playerName)[0], true
          playerName

      .ready () =>
        # wait for animation to complete
        setTimeout(() =>
          @ui.playerTypeAhead.focus()
        , 600)
      .keypress () =>
        @ui.newPlayerIcon.popover 'hide'

      @ui.newPlayerIcon.tooltip
        title: 'Add new player'
        placement: 'right'

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
      player.set 'staged', staged ? true : undefined
      numOfPlayersStaged = @players.where(staged: true).length

      if staged
        @collection.add player
        setTimeout(() =>
          @ui.playerTypeAhead.val ''
        , 10)
      else
        @collection.remove player

    _updateTypeAheadSource: () ->
      unstagedPlayerList = @players.where(staged: undefined)
      updatedSource = _.chain(unstagedPlayerList)
               .pluck('attributes')
               .pluck("name")
               .value()

      if @collection.length < 4
        @trigger 'notready'
      else
        @trigger 'ready'

      @ui.playerTypeAhead.data('typeahead').source = updatedSource

    _ready: () ->
      @ui.playerTypeAhead.attr 'disabled', 'disabled'
      @ui.newPlayerIcon.removeClass 'pointer'

    _notready: () ->
      @ui.playerTypeAhead.removeAttr 'disabled'
      @ui.newPlayerIcon.addClass 'pointer'
