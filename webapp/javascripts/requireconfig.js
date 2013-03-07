require.config({
    paths: {
        jquery: 'libs/jquery/jquery-min',
        underscore: 'libs/underscore/underscore-min',
        backbone: 'libs/backbone/backbone-min',
        marionette: 'libs/backbone/backbone.marionette.min',
        'backbone.wreqr': 'libs/backbone/backbone.wreqr.min',
        'backbone.babysitter': 'libs/backbone/backbone.babysitter.min',

        text: 'libs/require/text',
        order: 'libs/require/order',

        templates: '../templates'
    },
    shim: {
        jquery: {
            exports: 'jQuery'
        },
        underscore: {
            exports: '_'
        },
        backbone: {
            deps: ['jquery', 'underscore'],
            exports: 'Backbone'
        },
        marionette: {
            deps: ['jquery', 'underscore', 'backbone'],
            exports: 'Marionette'
        },
        'backbone.wreqr': ['backbone'],
        'backbone.babysitter': ['backbone']
    },
    urlArgs: "bust=" + (new Date()).getTime()

});