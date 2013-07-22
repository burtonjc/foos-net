define [
  'jquery'
  'underscore'
  'backbone.loader'
  'cryptojs'
  'tpl!templates/game/resultsrecorder.html'

], ($, _, Backbone, CryptoJS, ResultsRecorderTpl) ->

  Backbone.Marionette.ItemView.extend
    template: ResultsRecorderTpl
    className: 'results-recorder'

    ui:
      pairButtons: '.btn.pair'
      activePair: '.btn.pair.active'

    events:
      'click .pair': 'onPairClicked'

    templateHelpers:
      getPairDisplayName: (idx) ->
        pair = @pairs[idx]

        return [
          '<div class="player">'
            '<img class="img-rounded" src="http://www.gravatar.com/avatar/'+CryptoJS.MD5(pair.at(0).get('player').get('email'))+'?d=mm&s='+70+'">'
            '&nbsp'
            pair.at(0).get('player').get('name')
            '<br /><br />'
            '<img class="img-rounded" src="http://www.gravatar.com/avatar/'+CryptoJS.MD5(pair.at(1).get('player').get('email'))+'?d=mm&s='+70+'">'
            '&nbsp'
            pair.at(1).get('player').get('name')
          '</div>'
        ].join('')

    initialize: (opts) ->
      @templateHelpers.pairs = opts.pairs
      @pairs = opts.pairs

    onPairClicked: (evt) ->
      @ui.pairButtons.removeClass('active')
      button = if $(evt.target).is '.btn.pair' then $(evt.target) else $(evt.target).parents '.btn.pair'
      button.addClass 'active'
      @_setResults @ui.pairButtons.index(button)

      @trigger 'ready'

    onRender: () ->
      @trigger 'notready'

    _setResults: (winnerIdx) ->
      @results =
        winners: @pairs[winnerIdx],
        losers: @pairs[if winnerIdx then 0 else 1]

    getResults: () ->
      @results
