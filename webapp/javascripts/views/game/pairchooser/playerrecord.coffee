define [
  'jquery'
  'underscore'
  'marionette'
  'collections/playermatches'
  'tpl!templates/game/pairchooser/playerrecord.html'

], ($, _, Marionette, PlayerMatches, PlayerRecordTpl) ->

  Marionette.ItemView.extend
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
      @player = opts.player
      @playerMatches = new PlayerMatches(player: @player).fetch()

    onRender: ->
      @playerMatches.then (matches) =>
        gameCount = _.countBy matches, (match) =>
          if _.contains(match.winners, @player.id) then 'win' else 'loss'

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
