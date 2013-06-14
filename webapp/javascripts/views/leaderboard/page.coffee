define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/leaderboard/page.html'
  'views/game/pairchooser/playercard'
  'views/league/list'
  'views/player/list'
  'views/ui/chooser'
  'domain/cache'

], ($, _, Backbone, LeaderBoardPageTpl, PlayerCard, LeagueListView, PlayerList, ChooserView, DomainCache) ->
  
  Backbone.Marionette.Layout.extend
    className: 'leaderboard'
    template: LeaderBoardPageTpl

    ui:
      chosenLeague: '.chosen-league'

    regions:
      playersRegion: '.players'
      leaguesRegion: '.leagues'

    collection: new (DomainCache.getCollection('players'))()

    initialize: (opts) ->
      leagueView = new LeagueListView
      @leagueChooser = new ChooserView
        searchPrompt: 'Search for a league...'
        collectionType: 'leagues'
        modelStageView: leagueView
        replaceSelection: true
        hideStage: true

      @playerListView = new PlayerList
        hideElo: false
        stationary: true
        permanent: true

      @listenTo @leagueChooser, 'model:staged', (league) ->
        @playerListView.setLeague league
        @playerListView.collection = new (DomainCache.getCollection('leagueplayers'))(league: league)
        @playerListView.collection.fetch().done (players) =>
          @ui.chosenLeague.html league.get('name')
          @playerListView.render()
          setTimeout =>
            @playerListView.collection.comparator = (player) =>
              membership = player.get('memberships').findWhere(league: league)
              if membership?
                -membership.get('rating')
            @playerListView.collection.sort()
            @playerListView.render()
          , 200


    onRender: ->
      @leaguesRegion.show @leagueChooser
      @playersRegion.show @playerListView

    onClose: ->
      @playerListView.collection.reset()
