define [
  'jquery'
  'underscore'
  'marionette'
  'tpl!templates/league/create.html'

], ($, _, Marionette, LeagueCreateTpl) ->
  Marionette.ItemView.extend
    template: LeagueCreateTpl

    initialize: ->
      @modelBinder = new Backbone.ModelBinder

    onRender: ->
      @modelBinder.bind @model, @el

    getLeague: ->
      @model
