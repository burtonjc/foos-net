define([
    'backbone',
    'models/player'
], function(Backbone, Player) {
    return Backbone.Collection.extend({
        url: '/players',
        model: Player
    });
});