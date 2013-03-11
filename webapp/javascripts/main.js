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
    urlArgs: "bust=" + (new Date()).getTime(),
    deps: [
        'foosnet'
    ],
    callback: function(FoosNet) {
        FoosNet.start();
    }
});
