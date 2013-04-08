define([
    'jquery',
    'underscore',
    'marionette',
    'cryptojs',
    'tpl!templates/game/resultsrecorder.html'
], function($, _, Marionette, CryptoJS, ResultsRecorderTpl) {
    return Marionette.ItemView.extend({
        template: ResultsRecorderTpl,
        className: 'results-recorder',

        ui: {
            pairButtons: '.btn.pair',
            activePair: '.btn.pair.active'
        },

        events: {
            // 'click .player': 'onPairClicked',
            // 'click .img-rounded': 'onPairClicked',
            'click .pair': 'onPairClicked'
        },

        templateHelpers: {
            getPairDisplayName: function(idx) {
                var pair = this.pairs[idx];

                return [
                    '<div class="player">',
                        '<img class="img-rounded" src="http://www.gravatar.com/avatar/'+CryptoJS.MD5(pair.at(0).get('email'))+'?d=mm&s='+70+'">',
                        '&nbsp;',
                        pair.at(0).get('name'),
                        '<br /><br />',
                        '<img class="img-rounded" src="http://www.gravatar.com/avatar/'+CryptoJS.MD5(pair.at(1).get('email'))+'?d=mm&s='+70+'">',
                        '&nbsp;',
                        pair.at(1).get('name'),
                    '</div>'
                ].join('');
            }
        },

        initialize: function(opts) {
            this.templateHelpers.pairs = opts.pairs;
            this.pairs = opts.pairs;
        },

        onPairClicked: function(evt) {
            this.ui.pairButtons.removeClass('active');
            button = $(evt.target).is('.btn.pair') ? $(evt.target) : $(evt.target).parents('.btn.pair');
            button.addClass('active');
            this._setResults(this.ui.pairButtons.index(button));

            this.trigger('ready');
        },

        onRender: function() {
            this.trigger('notready');
        },

        _setResults: function(winnerIdx) {
            this.results = {
                winners: this.pairs[winnerIdx],
                losers: this.pairs[winnerIdx ? 0 : 1]
            };
        },

        getResults: function() {
            return this.results;
        }
    });
});