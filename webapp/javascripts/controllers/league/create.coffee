define [
  'jquery'
  'underscore'
  'controllers/modal'
  'domain/cache'
  'views/league/create'
  'views/league/invite'

], ($, _, ModalController, DomainCache, LeagueCreateView, LeagueInviteView) ->
  ModalController.extend
    sequence: [
      (next) ->
        League = DomainCache.getModel 'league'
        league = new League
        @showView new LeagueCreateView(model: league),
          header: 'Create league...'
          primaryBtn: 'Finish'
          submit: ->
            league.save null,
              success: (model, response, opts) ->
                next(league)

      # Need to force update of players/ratings when league players change before we enable this functionality
      # (league, next) ->
      #   PlayerCollection = DomainCache.getCollection 'players'
      #   league.set 'players', new PlayerCollection
      #   @showView new LeagueInviteView(collection: league.get('players')),
      #     header: 'Invite players...'
      #     primaryBtn: 'Finish'
      #     submit: ->
      #       league.save null,
      #         success: ->
      #           next()
    ]
