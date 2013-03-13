define([
    'jquery',
    'underscore',
    'marionette',
    'views/modal/layout',
    'views/game/playerchooser',
    'views/game/header',
    'views/game/footer',
    'views/game/alert',
    'views/game/pairchooser/pairchooser'

], function($, _, Marionette, ModalLayout, PlayerChooser, GameHeader, GameFooter, GameAlert, PairChooser) {
    return Marionette.Controller.extend({

        initialize: function(opts) {
            this.region = opts.region;
        },

        playGame: function() {
            this.layout = new ModalLayout();
            this.region.show(this.layout);

            this.layout.header.show(new GameHeader());
            this.layout.footer.show(new GameFooter());

            this._choosePlayers();
        },

        _choosePlayers: function() {
            var playerchooser = new PlayerChooser(),
                footer = this.layout.footer.currentView;

            this._transitionView("Choose your players...", playerchooser);

            footer.once('next', function() {
                this._choosePairs(playerchooser.collection);
            }, this);
        },

        _choosePairs: function(players) {
            var footer = this.layout.footer.currentView,
                pairchooser = new PairChooser({
                    players: players
                });

            this._transitionView("Choose your pairs...", pairchooser);

            footer.once('next', function() {
                this._recordResults(pairchooser.getPairs());
            }, this);
        },

        _recordResults: function(pairs) {
            var footer = this.layout.footer.currentView;

            footer.ui.btnNext.html("Finish");

            // this._transitionView("Record your results...", new ResultsRecorder({
            //     pairs: pairs
            // }));

            footer.once('next', this._closeOutModal, this);
        },

        _transitionView: function(headerText, view) {
            var me = this,
                header = me.layout.header.currentView,
                footer = me.layout.footer.currentView;

            me.stopListening(this.layout.body.currentView);

            header.setLabel("Choose your pairs...");

            me.listenTo(view, 'error', function(message) {
                me.layout.alert.show(new GameAlert({message: message}));
            });
            me.listenTo(view, 'notready', footer.deactivate);
            me.listenTo(view, 'ready', footer.activate);
            me.layout.body.show(view);
        },

        _closeOutModal: function() {
            var me = this,
                modal = $(me.layout.el).find('.modal');

            modal.on('hidden', function() {
                me.layout.destroyRegions();
                me.layout.remove();
            });
            modal.modal('hide');
        }
    });
});