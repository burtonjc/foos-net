define [
  'backbone.loader'
  'text!templates/footer.html'

], (Backbone, FooterTpl) ->

  Backbone.Marionette.ItemView.extend
    template: FooterTpl
