define([
    'jquery',
    'underscore',
    'marionette',
    'models/player',
    'tpl!templates/game/playerlistrow.html'
], function($, _, Marionette, Player, PlayerListRowTpl) {
    return Marionette.ItemView.extend({
        template: PlayerListRowTpl,
        model: Player,
        tagName: 'tr',

        initialize: function(opts) {
            this.templateHelpers = {
                hideX: opts.hideX || false
            };
        }
    });
});