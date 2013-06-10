define [
  'jquery'
  'underscore'
  'marionette'
  'collections/players'
  'tpl!templates/ui/typeahead.html'

], ($, _, Marionette, PlayersCollection, PlayerTypeAheadTpl) ->

  Marionette.ItemView.extend
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

    remove: (model) ->
      @collection.remove model

    add: (model) ->
      @collection.add model

    disable: () ->
      @ui.playerTypeAhead.attr 'disabled', 'disabled'

    enable: () ->
      @ui.playerTypeAhead.removeAttr 'disabled'

    focus: () ->
      @ui.playerTypeAhead.focus()
