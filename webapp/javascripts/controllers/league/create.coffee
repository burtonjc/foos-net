define [
  'jquery'
  'underscore'
  'marionette'
  'models/league'
  'collections/players'
  'views/modal/layout'
  'views/league/create'
  'views/league/invite'

], ($, _, Marionette, League, PlayerCollection, ModalLayout, LeagueCreate, LeagueInvite) ->
  Marionette.Controller.extend

    initialize: (opts) ->
      region = opts.region
      @layout = new ModalLayout
      region.show @layout
      
      @league = new League
      @_createLeague()

    _createLeague: ->
      @layout.show new LeagueCreate(model: @league), 'Create League...'

      @listenTo @layout, 'next', () =>
        @league.save null,
          success: (model, resp, opts) =>
            @stopListening @layout, 'next'
            @_invitePlayers(model)
          error: (model, xhr, opts) =>
            @layout.currentView.trigger 'error', 'unable to create league'

    _invitePlayers: (league) ->
      @league.set('players', new PlayerCollection)
      @layout.show new LeagueInvite(collection: @league.get('players')), 'Add players to your league...', 'Finish'

      @listenToOnce @layout, 'next', () =>
        @league.save()
        @_closeOutModal()

    _closeOutModal: () ->
      modal = $(@layout.el).find '.modal'

      modal.on 'hidden', () =>
        @layout.close()
        @layout.remove()

      modal.modal 'hide'
