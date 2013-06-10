define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/ui/chooser'
  'views/player/list'
  'views/league/list'
  'collections/playerleagues'

], ($, _, ModalController, ChooserView, PlayerListView, LeagueListView, PlayerLeaguesCollection) ->
  ModalController.extend
    sequence: [
      (next) ->
        playerChooser = new ChooserView
          collectionPath: 'collections/players'
          count: 1
          searchPrompt: 'Search for your player...'
          modelStage: new PlayerListView

        @showView playerChooser,
          header: 'Select your player...'
          submit: ->
            next(playerChooser.getModels().at(0))

      (player, next) ->
        playerLeagues = new PlayerLeaguesCollection(player: player)
        playerLeagues.fetch
          success: (collection, response, opts) ->
            next(player, collection)

      (player, playerLeagues, next) ->
        leagueChooser = new ChooserView
          collectionPath: 'collections/leagues'
          searchPrompt: 'Search for leagues...'
          modelStage: new LeagueListView
            collection: playerLeagues

        @showView leagueChooser,
          header: 'Choose leagues to join...'
          primaryBtn: 'Finish'
          submit: ->
            player.save {leagues: _.pluck(leagueChooser.getModels().models, 'id')},
              success: -> next()
    ]
