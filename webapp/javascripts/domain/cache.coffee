define ->
  class DomainCache
    instance: null

    class _DomainCache_
      _cache:
        domain:
          models: {}
          collections: {}

      addModel: (name, model) ->
        return null unless _.isString(name) and (model.prototype instanceof Backbone.Model)
        @_cache.domain.models[name.toLowerCase()] = model
        model
      getModel: (name) ->
        return null unless _.isString(name)
        @_cache.domain.models[name.toLowerCase()]
      getModels: -> @_cache.domain.models

      addCollection: (name, collection) ->
        return null unless _.isString(name) and (collection.prototype instanceof Backbone.Collection)
        @_cache.domain.collections[name.toLowerCase()] = collection
        collection
      getCollection: (name) ->
        return null unless _.isString(name)
        @_cache.domain.collections[name.toLowerCase()]
      getCollections: -> @_cache.domain.collections

    @get: ->
      @instance ?= new _DomainCache_()

  DomainCache.get()
