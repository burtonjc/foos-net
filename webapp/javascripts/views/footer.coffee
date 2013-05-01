define [
  'marionette'
  'text!templates/footer.html'

], (Marionette, FooterTpl) ->

  Marionette.ItemView.extend
    template: FooterTpl
