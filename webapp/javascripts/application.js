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
    // Due to how dependencies are loaded, we need jquery, underscore,
    // and backbone loaded in this order right at the top.
    'jquery',
    'underscore',
    'backbone',
    'marionette',
    'views/navigation',
    'views/footer',
    'router'
], function($, _, Backbone, Marionette, Navigation, Footer, AppRouter) {
    FoosNet = new Marionette.Application();
    FoosNet.addRegions({
        navigation: "#top-nav",
        page: "#page-container",
        footer: "#footer"

    });

    FoosNet.navigation.show(new Navigation({}));
    FoosNet.footer.show(new Footer({}));

    FoosNet.addInitializer(function(options) {
        new AppRouter(FoosNet);
        Backbone.history.start();
    });

    FoosNet.start();
});