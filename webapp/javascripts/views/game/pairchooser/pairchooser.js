define([
    'jquery',
    'jqueryui',
    'underscore',
    'marionette',
    'views/game/pairchooser/pairwell',
    'collections/players',
    'tpl!templates/game/pairchooser/pairchooser.html'
], function($, jqueryui, _, Marionette, PairWell, PlayersCollection, PairChooserTpl) {
    return Marionette.Layout.extend({
        template: PairChooserTpl,
        className: 'pair-chooser',

        players: null,

        regions: {
            pairOneCt: '.pair-ct.one',
            pairTwoCt: '.pair-ct.two'
        },

        ui: {
            pairOneElo: '.pair-elo.one',
            pairTwoElo: '.pair-elo.two'
        },

        initialize: function(opts) {
            this.players = opts.players;
        },

        onRender: function() {
            this.pairOneCt.show(this._getNextPairView(this.players));
            this.pairTwoCt.show(this._getNextPairView(this.players));

            this._updatePairEloRaitings();
            this._initializeDragDrop();
        },

        getPairs: function() {
            return [
                this.pairOneCt.currentView.collection,
                this.pairTwoCt.currentView.collection
            ];
        },

        _initializeDragDrop: function() {
            var me = this,
                pairOneView = me.pairOneCt.currentView,
                pairTwoView = me.pairTwoCt.currentView;

            me.listenTo(pairOneView, 'drag:dropped', function(playerCard) {
                var model = playerCard.model;

                pairOneView.collection.remove(model);
                pairTwoView.collection.add(model);

                me._checkReady();
                me._updatePairEloRaitings();
            });

            me.listenTo(pairTwoView, 'drag:dropped', function(playerCard) {
                var model = playerCard.model;

                pairTwoView.collection.remove(model);
                pairOneView.collection.add(model);

                me._checkReady();
                me._updatePairEloRaitings();
            });

        },

        _getNextPairView: function(players) {
            var pair = new PlayersCollection();

            pair.add([players.shift(), players.pop()]);

            return new PairWell({
                collection: pair
            });
        },

        _updatePairEloRaitings: function() {
            var pairOnePlayers = this.pairOneCt.currentView.collection,
                pairTwoPlayers = this.pairTwoCt.currentView.collection,
                pairOneElos = _.chain(pairOnePlayers.models).pluck('attributes').pluck('elo').value(),
                pairTwoElos = _.chain(pairTwoPlayers.models).pluck('attributes').pluck('elo').value();

                this.ui.pairOneElo.html(this._average(pairOneElos));
                this.ui.pairTwoElo.html(this._average(pairTwoElos));
        },

        _checkReady: function() {
            var pairOnePlayers = this.pairOneCt.currentView.collection,
                pairTwoPlayers = this.pairTwoCt.currentView.collection;

            if (pairOnePlayers.length == 2 && pairTwoPlayers.length === 2) {
                this.trigger('ready');
            } else {
                this.trigger('notready');
            }
        },

        _average: function (arr) {
            return _.reduce(arr, function(memo, num) {
                return memo + num;
            }, 0) / arr.length;
        }
    });
});