// Filename: router.js
define([
    'underscore',
    'jquery',
    'marionette'
], function (_, $, Marionette) {
	return Marionette.AppRouter.extend({
        Application: null,

		routes: {
            'leaderboard': 'leaderboardPage',
            'stats': 'statsPage',

            // Keep default route as the last one
            '*actions': 'homePage'
		},

        initialize: function(Application) {
            this.Application = Application;
        },

        homePage: function() {
            var app = this.Application;
            require(['views/home/page'], function (HomePage) {
                app.page.show(new HomePage());
            });
        },

        leaderboardPage: function() {},

        statsPage: function() {}
    });
});
