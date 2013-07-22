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

    templateHelpers: {}

    initialize: (opts) ->
      @vent = opts.vent
      @templateHelpers.placeholder = opts.placeholder ? "Search..."
      @displayAttribute = opts.displayAttribute ? 'name'

    onClose: ->
      @collection.reset()
      @ui.playerTypeAhead.typeahead().remove()

    onRender: ->
      getDisplayValues = =>
        values = @collection.models
        for property in @displayAttribute.split "."
          values = (for model in values
            model.get(property))
        values

      @collection.fetch
        success: (collection, response, options) =>
          @ui.playerTypeAhead.typeahead
            source: (query, process) =>
              _.filter getDisplayValues(), (attribute) ->
                attribute.toLowerCase().indexOf(query.toLowerCase()) isnt -1

            updater: (item) =>
              model = @collection.at getDisplayValues().indexOf(item)

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
