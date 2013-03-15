define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/leaderboard/page.html',
    'views/game/playerlistrow',
    'collections/players'
], function($, _, Marionette, LeaderBoardPageTpl, PlayerListRow, PlayersCollection) {
    return Marionette.CompositeView.extend({
        className: 'hero-unit leaderboard',
        template: LeaderBoardPageTpl,
        itemView: PlayerListRow,
        itemViewOptions: {
            hideX: true,
        },
        itemViewContainer: 'tbody',

        initialize: function(opts) {
            var me = this;

            new PlayersCollection().fetch({
                success: function(collection, response, options) {
                    me.collection = collection;
                    me.renderCollection();
                }
            });
        }
    });
});