require.config
  name: 'main'
  paths:
    backbone: '../lib/backbone.marionette/backbone'
    'backbone.babysitter': '../lib/backbone.marionette/backbone-babysitter-min'
    'backbone.modelbinder': '../lib/backbone.marionette/backbone-modelbinder-min'
    'backbone.collectionbinder': '../lib/backbone.marionette/backbone-collectionbinder-min'
    'backbone.wreqr': '../lib/backbone.marionette/backbone-wreqr-min'
    'bootstrap': '../lib/bootstrap/js/bootstrap'
    cryptojs: '../lib/cryptojs/md5'
    jquery: '../lib/jquery/jquery'
    marionette: '../lib/backbone.marionette/backbone-marionette'
    underscore: '../lib/underscore/underscore'

    text: '../lib/require/text'
    order: '../lib/require/order'
    tpl: '../lib/require/plugins/tpl'

    templates: '../templates'

  shim:
    backbone:
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    'backbone.babysitter': ['backbone']
    'backbone.modelbinder': ['backbone']
    'backbone.collectionbinder': ['backbone', 'backbone.modelbinder']
    'backbone.wreqr': ['backbone']
    jquery:
      exports: 'jQuery'
    marionette:
      deps: ['jquery', 'underscore', 'backbone']
      exports: 'Marionette'
    underscore:
      exports: '_'
    foosnet: ['underscore', 'jquery', 'marionette', 'backbone.modelbinder', 'backbone.collectionbinder']

  urlArgs: "bust=" + (new Date).getTime()
  deps: ['foosnet']
  callback: (FoosNet) ->
    FoosNet.start()
