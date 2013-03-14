define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/game/resultsrecorder.html'
], function($, _, Marionette, ResultsRecorderTpl) {
    return Marionette.ItemView.extend({
        template: ResultsRecorderTpl,
        className: 'results-recorder',

        ui: {
            pairButtons: '.btn.pair',
            activePair: '.btn.pair.active'
        },

        templateHelpers: {
            getPairDisplayName: function(idx) {
                var pair = this.pairs[idx];
                return pair.at(0).get('name') + '/' + pair.at(1).get('name');
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
                winner: this.pairs[winnerIdx],
                looser: this.pairs[winnerIdx ? 0 : 1]
            };
        },

        getResults: function() {
            return this.results;
        }
    });
});