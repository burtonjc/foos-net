define([
    'jquery',
    'underscore',
    'marionette',

    'views/modal/layout',
    'views/game/playerchooser',
    'views/game/footer',
    'views/game/alert'
], function($, _, Marionette, ModalLayout, PlayerChooser, GameFooter, GameAlert) {
    return Marionette.Controller.extend({
        initialize: function(opts) {
            this.region = opts.region;
        },

        playGame: function() {
            this.layout = new ModalLayout({
                label: 'Choose your players...'
            });
            this.region.show(this.layout);

            this.layout.footer.show(new GameFooter());

            this._choosePlayers();
        },

        _choosePlayers: function() {
            var playerchooser = new PlayerChooser(),
                footer = this.layout.footer.currentView;

            this.listenTo(playerchooser, 'error', function(message) {
                this.layout.alert.show(new GameAlert({message: message}));
            });
            this.listenTo(playerchooser, 'incomplete', footer.deactivate);
            this.listenTo(playerchooser, 'complete', footer.activate);
            this.layout.body.show(playerchooser);
        }
    });
});