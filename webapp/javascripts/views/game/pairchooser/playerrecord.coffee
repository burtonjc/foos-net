define [
  'jquery'
  'underscore'
  'marionette'
  'collections/playermatches'
  'tpl!templates/game/pairchooser/playerrecord.html'

], ($, _, Marionette, PlayerMatches, PlayerRecordTpl) ->

  Marionette.ItemView.extend
    template: PlayerRecordTpl
    className: 'player-record span12'
    tagName: 'div'

    ui:
      winBar: '.win-bar'
      lossBar: '.loss-bar'
      total: '.game-total'

    player: null
    playerMatches: null

    initialize: (opts) ->
      @player = opts.player
      @playerMatches = new PlayerMatches(player: @player).fetch()

    onRender: ->
      @playerMatches.then (matches) =>
        gameCount = _.countBy matches, (match) =>
          if _.contains(_.pluck(match.winners, '_id'), @player.id) then 'win' else 'loss'

        _.defaults(gameCount, {
          total: matches.length
          win: 0
          loss: 0
        })

        @ui.winBar.width "#{(gameCount.win/gameCount.total)*100}%"
        @ui.winBar.html gameCount.win
        @ui.lossBar.width "#{(gameCount.loss/gameCount.total)*100}%"
        @ui.lossBar.html gameCount.loss

        @ui.total.html "(#{gameCount.total})"
