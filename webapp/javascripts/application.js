require.config({
	paths: {
		backbone: 'libs/backbone.marionette/backbone',
        'backbone.wreqr': 'libs/backbone.marionette/backbone-wreqr-min',
        'backbone.babysitter': 'libs/backbone.marionette/backbone-babysitter-min',
        'bootstrap': '../lib/bootstrap/js/bootstrap',
        jquery: 'libs/jquery/jquery',
        marionette: 'libs/backbone.marionette/backbone-marionette',
        underscore: 'libs/underscore/underscore',

		text: 'libs/require/text',
		order: 'libs/require/order',

		templates: '../templates'
	},
    shim: {
        backbone: {
            deps: ['jquery', 'underscore'],
            exports: 'Backbone'
        },
        'backbone.wreqr': ['backbone'],
        'backbone.babysitter': ['backbone'],
        jquery: {
            exports: 'jQuery'
        },
        marionette: {
            deps: ['jquery', 'underscore', 'backbone'],
            exports: 'Marionette'
        },
        underscore: {
            exports: '_'
        }
    },
	urlArgs: "bust=" + (new Date()).getTime()
});

require([
    'jquery',
    'underscore',
    'backbone',
    'marionette',
    'router'
], function($, _, Backbone, Marionette, AppRouter, AppView) {
    FoosNet = new Marionette.Application();
    FoosNet.addRegions({
        topNav: "#top-nav",
        page: "#page-container",
        footer: "#footer"

    });

    $(FoosNet.topNav.el).delegate('li', 'click', function(a, b, c, d) {
        var activeCls = 'active';
        $(a.currentTarget.parentElement).find('.' + activeCls).removeClass(activeCls);
        $(a.currentTarget).addClass(activeCls);
    });

    FoosNet.addInitializer(function(options) {
        new AppRouter(FoosNet);
        Backbone.history.start();
    });

    FoosNet.start();
});