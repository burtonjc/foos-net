define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/ui/chooser'
  'views/player/list'
  'views/league/list'
  'domain/cache'

], ($, _, ModalController, ChooserView, PlayerListView, LeagueListView, DomainCache) ->
  ModalController.extend
    sequence: [
      (next) ->
        playerChooser = new ChooserView
          collectionType: 'players'
          count: 1
          searchPrompt: 'Search for your player...'
          modelStageView: new PlayerListView

        @showView playerChooser,
          header: 'Select your player...'
          submit: ->
            next playerChooser.getModels().at(0)

      (player, next) ->
        PlayerLeagues = DomainCache.getCollection 'playerleagues'
        playerleagues = new PlayerLeagues(player: player)
        playerleagues.fetch
          success: (collection, response, opts) ->
            next player, collection

        # PlayerMemberships = DomainCache.getCollection 'playermemberships'
        # playerMemberships = new PlayerMemberships(null, player: player)
        # playerMemberships.fetch
        #   success: (collection, response, opts) ->
        #     next player, collection

      (player, playerLeagues, next) ->
        leagueListView = new LeagueListView(collection: playerLeagues)

        leagueChooser = new ChooserView
          collectionType: 'leagues'
          searchPrompt: 'Search for leagues...'
          modelStageView: leagueListView

        @showView leagueChooser,
          header: 'Choose leagues to join...'
          primaryBtn: 'Finish'
          submit: ->
            memberships = player.get('memberships')
            memberships.fetch().done =>
              leagueChooser.getModels().each (league, idx) ->
                return if memberships.findWhere(league: league)?

                memberships.create
                  player: player
                  league: league
              next()

            # player.save {leagues: _.pluck(leagueChooser.getModels().models, 'id')},
            #   success: -> next()
    ]
