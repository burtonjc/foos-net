define([
    'jquery',
    'jqueryui',
    'underscore',
    'marionette',
    'views/game/pairchooser/playercard'
], function($, jqueryui, _, Marionette, PlayerCard) {
    return Marionette.CollectionView.extend({
        className: 'well pair-drop-ct',
        itemView: PlayerCard,

        triggers: {
            'collection:add': 'collection:add'
        },

        initialize: function(opts) {
            var me = this;
            me.on('itemview:drag:dropped', function(playerCard) {
                me.trigger('drag:dropped', playerCard);
            });
        },

        onRender: function() {
            var me = this;
            $(this.el).droppable({
                hoverClass: 'active',
                tolerence: 'intersect',
                drop: function(event, ui) {
                    var el = $(me.el);
                    ui.draggable.trigger('drag:dropped');
                }
            });
        }
    });
});