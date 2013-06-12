define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/ui/typeahead.html'

], ($, _, Backbone, PlayerTypeAheadTpl) ->

  class TypeAhead extends Backbone.Marionette.ItemView
    template: PlayerTypeAheadTpl
    className: 'ui-typeahead-view'

    ui:
      playerTypeAhead: 'input'
      
    collection: null
    vent: null

    displayAttribute: 'name'
    templateHelpers: {}

    initialize: (opts) ->
      @vent = opts.vent
      @templateHelpers.placeholder = opts.placeholder ? "Search..."

    onClose: ->
      @collection.reset()
      @ui.playerTypeAhead.typeahead().remove()

    onRender: ->
      @collection.fetch
        success: (collection, response, options) =>
          @ui.playerTypeAhead.typeahead
            source: (query, process) =>
              @collection.chain()
                .pluck('attributes')
                .pluck('name')
                .filter((name) ->
                  name.toLowerCase().indexOf(query.toLowerCase()) isnt -1
                ).value()

            updater: (item) =>
              query = {}
              query[@displayAttribute] = item
              model = @collection.where(query)[0]
              @trigger 'model:selected', model
              if @vent?
                @vent.trigger 'model:selected', model

              item

    val: (value) ->
      if value?
        @ui.playerTypeAhead.val value
      else
        @ui.playerTypeAhead.val()

    removeModel: (model) ->
      @collection.remove model

    addModel: (model) ->
      @collection.add model

    disable: () ->
      @ui.playerTypeAhead.attr 'disabled', 'disabled'

    enable: () ->
      @ui.playerTypeAhead.removeAttr 'disabled'

    focus: () ->
      @ui.playerTypeAhead.focus()
