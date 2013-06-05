define [
  'jquery'
  'underscore'
  'controllers/modal'
  'models/league'
  'collections/players'
  'views/league/create'
  'views/league/invite'

], ($, _, ModalController, League, PlayerCollection, LeagueCreateView, LeagueInviteView) ->
  ModalController.extend
    sequence: [
      () ->
        league = new League
        @showView new LeagueCreateView(model: league),
          header: 'Create league...'
          submit: (next) ->
            league.save null,
              success: (model, response, opts) ->
                next(league)

      (league) ->
        league.set 'players', new PlayerCollection
        @showView new LeagueInviteView(collection: league.get('players')),
          header: 'Invite players...'
          primaryBtn: 'Finish'
          submit: (next) =>
            league.save null,
              success: ->
                next()
    ]
