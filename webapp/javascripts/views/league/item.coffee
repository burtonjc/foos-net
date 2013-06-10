define [
  'jquery'
  'underscore'
  'marionette'
  'tpl!templates/league/item.html'

], ($, _, Marionette, LeagueItemTpl) ->
  Marionette.ItemView.extend
    template: LeagueItemTpl
    className: 'league-item-view row-fluid'

    events:
      'click .remove' : ->
        @vent?.trigger 'model:remove', @model
        @trigger 'remove', @model

    ui:
      removeIcon: '.remove'

    onRender: ->
      @ui.removeIcon.find('i').tooltip
        placement: 'left'
        title: 'Remove league...'
        trigger: 'manual'

      @ui.removeIcon.mouseenter () =>
        @ui.removeIcon.find('i').tooltip('show');
      @ui.removeIcon.mouseleave () =>
        @ui.removeIcon.find('i').tooltip('hide');
