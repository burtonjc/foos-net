define [
  'jquery'
  'underscore'
  'backbone.loader'
  'views/ui/typeahead'
  'tpl!templates/ui/chooser.html'

], ($, _, Backbone, TypeAhead, ChooserTpl) ->

  Backbone.Marionette.Layout.extend
    template: ChooserTpl
    className: 'ui-chooser-view'
      
    regions:
      modelSearchRegion: '.search-region'
      modelStageRegion: '.stage-region'

    modelSearchView: null
    modelStageView: null

    count: null

    initialize: (opts) ->
      _.bindAll @

      @count = opts.count ? @count

      @_getCollection(opts).done (Collection) =>
        @_initializeModelStage(opts.modelStage)
        @_initializeModelSearch(Collection, opts)
        @_checkReady()

    getModels: ->
      @modelStageView.collection
        
    _getCollection: (opts) ->
      collection = $.Deferred()
      require [opts.collectionPath], (col) =>
        collection.resolve col
      collection.promise()

    _initializeModelStage: (modelStageView) ->
      @modelStageView = modelStageView
      @modelStageRegion.show @modelStageView
      @listenTo @modelStageView, 'model:removed', (model) =>
        @_setModelStaged model, false

    _initializeModelSearch: (Collection, opts) ->
      collection = new Collection opts.collectionOpts ? {}
      @modelSearchView = new TypeAhead
        collection: collection
        placeholder: opts.searchPrompt
      @modelSearchRegion.show @modelSearchView

      @listenTo @modelSearchView, 'model:selected', (model) =>
        @_setModelStaged model, true

      $.when(@modelSearchView.$el).done(() =>
        setTimeout () => # i can't figure out a better way to wait for the animation
          @modelSearchView.focus()
        , 600
      )
      
      if @modelStageView.collection.length
        collection.fetch().done =>
          @modelSearchView.remove @modelStageView.collection.models

    _setModelStaged: (model, staged) ->
      if staged
        unless @modelStageView.collection.contains model
          @modelStageView.collection.add model
          @modelSearchView.remove model

        setTimeout(() =>
          @modelSearchView.val ''
        , 10)
      else
        if @modelStageView.collection.contains model
          @modelStageView.collection.remove model
          @modelSearchView.add model

      @_checkReady()

    _checkReady: ->
      return @_ready unless @count?

      if @modelStageView.collection.length is @count
        @_ready()
      else
        @_notready()

    _ready: ->
      @modelSearchView.disable()
      @trigger 'ready'

    _notready: ->
      @modelSearchView.enable()
      @trigger 'notready'
