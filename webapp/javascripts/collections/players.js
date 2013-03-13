define([
    'backbone',
    'models/player'
], function(Backbone, Player) {
    return Backbone.Collection.extend({
        url: '/players',
        model: Player,

        comparator: function(player) {
            return player.get("elo");
        }
    });
});