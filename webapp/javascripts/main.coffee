require.config
  name: 'main'
  paths:
    # Backbone paths ...
    'backbone'                  : '../lib/backbone/backbone-min'
    'backbone.babysitter'       : '../lib/backbone/marionette/backbone-babysitter-min'
    'backbone.collectionbinder' : '../lib/backbone/binder/backbone-collectionbinder-min'
    'backbone.marionette'       : '../lib/backbone/marionette/backbone-marionette'
    'backbone.modelbinder'      : '../lib/backbone/binder/backbone-modelbinder-min'
    'backbone.relational'       : '../lib/backbone/relational/backbone-relational'
    'backbone.wreqr'            : '../lib/backbone/marionette/backbone-wreqr-min'

    # 3rd party library paths ...
    'bootstrap'   : '../lib/bootstrap/js/bootstrap'
    'cryptojs'    : '../lib/cryptojs/md5'
    'jquery'      : '../lib/jquery/jquery'
    'underscore'  : '../lib/underscore/underscore'

    # Requirejs plugins ...
    'text'  : '../lib/require/text'
    'order' : '../lib/require/order'
    'tpl'   : '../lib/require/plugins/tpl'

    # Other paths ...
    'backbone.loader' : 'loaders/backbone'
    'templates'       : '../templates'

  shim:
    # Backbone shims ...
    'backbone':
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    'backbone.babysitter'       : ['backbone']
    'backbone.collectionbinder' : ['backbone', 'backbone.modelbinder']
    'backbone.marionette'       : ['backbone']
    'backbone.modelbinder'      : ['backbone']
    'backbone.relational'       : ['backbone']
    'backbone.wreqr'            : ['backbone']

    # 3rd party library shims ...
    'bootstrap': ['jquery']
    'underscore':
      exports: '_'

    # load domain objects
    # models must be loaded before collections
    'foosnet': ['backbone' #so that we have Backbone.Model and Backbone.Collection

                'domain/model/league'
                'domain/model/match'
                'domain/model/membership'
                'domain/model/player'

                'domain/collection/memberships'
                'domain/collection/leaguememberships'
                'domain/collection/leagueplayers'
                'domain/collection/leagues'
                'domain/collection/playerleagues'
                'domain/collection/playermatches'
                'domain/collection/playermemberships'
                'domain/collection/players'
              ]

  urlArgs: "bust=" + (new Date).getTime()
  deps: ['bootstrap', 'foosnet']
  callback: (Bootstrap, FoosNet) ->
    FoosNet.start()
