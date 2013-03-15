define([
    'jquery',
    'jqueryui',
    'underscore',
    'marionette',
    'models/player',
    'cryptojs',
    'tpl!templates/game/pairchooser/playercard.html'
], function($, jqueryui, _, Marionette, Player, CryptoJS, PlayerCardTpl) {
    return Marionette.ItemView.extend({
        template: PlayerCardTpl,
        className: 'player-card img-rounded',
        tagName: 'div',
        model: Player,

        triggers: {
            'drag:dropped': 'drag:dropped'
        },

        initialize: function(opts) {
            this.templateHelpers = {
                imgSize: opts.imgSize || 30,
                emailHash: CryptoJS.MD5(this.model.get('email').trim().toLowerCase())
            };
        },

        onRender: function() {
            var me = this;
            $(me.el).draggable({
                revert: 'invalid'
            });
        }
    });
});