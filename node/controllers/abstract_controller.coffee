define [
  'underscore'
], (_) ->

  class AbstractController
    instance: null
    @getInstance: ->
      @instance ?= new @

    model: null
    defaultSort: '-_id'
    defaultSelect: null
    defaultPopulate: null

    constructor: ->
      # throw Error 'Controller must define a model' unless model?
      
      _.bindAll @, 'buildQuery', 'applyFetchTo', '_errorHandler'
      for method in ['get', 'query', 'update', 'delete', 'create']
        if @[method]
          _.bind @, method
          @[method] = _.wrap @[method], @_errorHandler

    buildQuery: (id) ->
      if id?
        query = @model.findById id
      else
        query = @model.find()
        query = query.sort(@defaultSort) if @defaultSort?

      @applyFetchTo(query)

    applyFetchTo: (query) ->
      query.select @defaultSelect if @defaultSelect?

      _.each @defaultPopulate, (select, refName) ->
        query.populate refName, select

      query

    _errorHandler: (fn, request, response, next) ->
      try
        fn.apply @, _.toArray(arguments).slice(1)
      catch e
        response.send 500,
          error: e.name
          message: e.message
          stack: e.stack
