define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/league/create.html'

], ($, _, Backbone, LeagueCreateTpl) ->
  Backbone.Marionette.ItemView.extend
    template: LeagueCreateTpl

    initialize: ->
      @modelBinder = new Backbone.ModelBinder

    onRender: ->
      @modelBinder.bind @model, @el

    getLeague: ->
      @model
