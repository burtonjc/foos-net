define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'views/ui/typeahead'
  'tpl!templates/ui/chooser.html'

], ($, _, Backbone, DomainCache, TypeAhead, ChooserTpl) ->

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
      _.extend @, opts

    onRender: ->
      @_initializeModelStage()
      @_initializeModelSearch()
      @_checkReady()

    getModels: ->
      @modelStageView.collection
        
    _initializeModelStage: ->
      unless @hideStage
        @modelStageRegion.show @modelStageView

      @listenTo @modelStageView, 'model:removed', (model) =>
        @_setModelStaged model, false

    _initializeModelSearch: ->
      Collection = DomainCache.getCollection(@collectionType)
      collection = new Collection @collectionOpts ? {}
      @modelSearchView = new TypeAhead
        collection: collection
        placeholder: @searchPrompt

      @listenTo @modelSearchView, 'model:selected', (model) =>
        @_setModelStaged model, true

      $.when(@modelSearchView.$el).done(() =>
        setTimeout () => # i can't figure out a better way to wait for the animation
          @modelSearchView.focus()
        , 500
      )
      
      if @modelStageView.collection.length
        collection.on 'sync', (collection, options) =>
          @modelSearchView.removeModel @modelStageView.collection.models

      @modelSearchRegion.show @modelSearchView

    _setModelStaged: (model, staged) ->
      if staged
        unless @modelStageView.collection.contains model
          if @replaceSelection
            @_setModelStaged @modelStageView.collection.at(0), false

          @modelStageView.collection.add model
          @modelSearchView.removeModel model

          @trigger 'model:staged', model

        setTimeout(() =>
          @modelSearchView.val ''
        , 10)
      else
        if @modelStageView.collection.contains model
          @modelStageView.collection.remove model
          @modelSearchView.addModel model

          @trigger 'model:unstaged', model

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
