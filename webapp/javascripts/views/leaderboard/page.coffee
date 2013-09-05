define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/leaderboard/page.html'
  'views/game/pairchooser/playercard'
  'views/league/list'
  'views/membership/list'
  'views/ui/chooser'
  'domain/cache'

], ($, _, Backbone, LeaderBoardPageTpl, PlayerCard, LeagueListView, MembershipList, ChooserView, DomainCache) ->

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

      @membershipListView = new MembershipList
        hideElo: false
        stationary: true
        permanent: true

      @listenTo @leagueChooser, 'model:staged', (league) ->
        @membershipListView.collection = new (DomainCache.getCollection('leaguememberships'))(null, league: league)
        @membershipListView.collection.fetch().done (memberships) =>
          @ui.chosenLeague.html league.get('name')
          @membershipListView.render()

    onRender: ->
      @leaguesRegion.show @leagueChooser
      @playersRegion.show @membershipListView

    onClose: ->
      @membershipListView.collection?.reset()
