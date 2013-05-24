require.config
  name: 'main'
  paths:
    backbone: '../lib/backbone.marionette/backbone'
    'backbone.wreqr': '../lib/backbone.marionette/backbone-wreqr-min'
    'backbone.babysitter': '../lib/backbone.marionette/backbone-babysitter-min'
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
    'backbone.wreqr': ['backbone']
    'backbone.babysitter': ['backbone']
    jquery:
      exports: 'jQuery'
    marionette:
      deps: ['jquery', 'underscore', 'backbone']
      exports: 'Marionette'
    underscore:
      exports: '_'

  urlArgs: "bust=" + (new Date()).getTime()
  deps: ['foosnet']
  callback: (FoosNet) ->
    FoosNet.start()
