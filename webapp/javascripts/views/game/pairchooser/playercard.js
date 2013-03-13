define([
    'jquery',
    'jqueryui',
    'underscore',
    'marionette',
    'models/player',
    'tpl!templates/game/pairchooser/playercard.html'
], function($, jqueryui, _, Marionette, Player, PlayerCardTpl) {
    return Marionette.ItemView.extend({
        template: PlayerCardTpl,
        className: 'player-card img-rounded',
        tagName: 'div',
        model: Player,

        triggers: {
            'drag:dropped': 'drag:dropped'
        },

        onRender: function() {
            var me = this;
            $(me.el).draggable({
                revert: 'invalid'
            });
        }
    });
});