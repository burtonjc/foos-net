define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'tpl!templates/membership/record.html'
], ($, _, Backbone, DomainCache, PlayerRecordTpl) ->

  Backbone.Marionette.ItemView.extend
    template: PlayerRecordTpl
    className: 'player-record'
    tagName: 'div'

    ui:
      winBar: '.win-bar'
      lossBar: '.loss-bar'
      total: '.game-total'

    player: null
    playerMatches: null

    initialize: (opts) ->
      @membership = opts.membership
      PlayerMatches = DomainCache.getCollection 'playermatches'
      @playerMatches = new PlayerMatches(player: @model.get('player')).fetch()

    onRender: ->
      @playerMatches.then (matches) =>
        matches = _.filter matches, (match) =>
          match.league is @model.get('league').id
        gameCount = _.countBy matches, (match) =>
          if _.contains(match.winners, @model.get('player').id) then 'win' else 'loss'

        _.defaults(gameCount, {
          total: matches.length
          win: 0
          loss: 0
        })

        @ui.winBar.width if gameCount.win > 0 then "#{(gameCount.win/gameCount.total)*100}%" else '10px';
        @ui.winBar.html gameCount.win
        @ui.lossBar.width if gameCount.loss > 0 then "#{(gameCount.loss/gameCount.total)*100}%" else '10px'
        @ui.lossBar.html gameCount.loss

        @ui.total.html "(#{gameCount.total})"
