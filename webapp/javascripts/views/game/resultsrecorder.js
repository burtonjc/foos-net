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

        triggers: {
            'click .player': 'click .pair'
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

        onRender: function() {
            var me = this;

            me.trigger('notready');
            me.$el.delegate('.btn.pair', 'click', function(evt) {
                me.ui.pairButtons.removeClass('active');
                $(evt.target).addClass('active');
                me._setResults(me.ui.pairButtons.index(evt.target));

                me.trigger('ready');
            });
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