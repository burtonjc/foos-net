require.config({
	paths: {
		backbone: 'libs/backbone.marionette/backbone',
        'backbone.wreqr': 'libs/backbone.marionette/backbone-wreqr-min',
        'backbone.babysitter': 'libs/backbone.marionette/backbone-babysitter-min',
        bootstrap: '../lib/bootstrap/js/bootstrap.js',
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
        bootstrap: ['jquery'],
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
    'backbone',
    'marionette',
    'views/app',
    'views/messages/composite',
    'views/messages/item',
    'collections/messages'
], function(Backbone, Marionette, AppView, MessageCompositeView, MessageItemView, Messages) {//AppView, Router, Vm) {
    FoosNet = new Marionette.Application();
    FoosNet.addRegions({
        page: "#content"
    });

    FoosNet.addInitializer(function(options) {
        new Messages().fetch({
            success: function(messages) {
                FoosNet.page.show(new MessageCompositeView({collection: messages}));
                // FoosNet.page.show(new MessageCompositeView());
            }
        });
    });

    $(document).ready(function() {
        FoosNet.start();
    });
});