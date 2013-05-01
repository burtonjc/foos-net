define [
  'jquery'
  'jqueryui'
  'underscore'
  'marionette'
  'views/game/pairchooser/playercard'

], ($, jqueryui, _, Marionette, PlayerCard) ->

  Marionette.CollectionView.extend
    className: 'well pair-drop-ct'
    itemView: PlayerCard

    triggers:
      'collection:add': 'collection:add'

    initialize: (opts) ->
      @on 'itemview:drag:dropped', (playerCard) =>
        @trigger 'drag:dropped', playerCard

    onRender: () ->
      $(this.el).droppable
        hoverClass: 'active'
        tolerence: 'intersect'
        drop: (event, ui) =>
          el = $(@el)
          ui.draggable.trigger 'drag:dropped'
