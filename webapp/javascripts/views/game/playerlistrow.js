define([
    'jquery',
    'underscore',
    'marionette',
    'cryptojs',
    'models/player',
    'tpl!templates/game/playerlistrow.html'
], function($, _, Marionette, CryptoJS, Player, PlayerListRowTpl) {
    return Marionette.ItemView.extend({
        template: PlayerListRowTpl,
        model: Player,
        tagName: 'tr',

        triggers: {
            'click .icon-remove': 'removeclicked'
        },

        initialize: function(opts) {
            this.templateHelpers = {
                imgSize: opts.imgSize || 60,
                emailHash: CryptoJS.MD5(this.model.get('email').trim().toLowerCase()),
                hideX: opts.hideX || false
            };
        }
    });
});