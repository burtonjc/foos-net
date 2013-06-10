define [
  'jquery'
  'backbone.loader'
  'text!templates/navigation.html'

], ($, Backbone, NavigationTpl) ->

  Backbone.Marionette.ItemView.extend
    template: NavigationTpl

    onRender: () ->
      @_setActiveItem(window.location.hash)
      @$el.delegate 'a', 'click', (event) =>
        @_setActiveItem $(event.currentTarget).attr('href')

    _setActiveItem: (href='#') ->
      if href is ''
        href = '#'
      activeCls = 'active'
      ul = @$el.first('ul')
      ul.find('.' + activeCls).removeClass activeCls
      ul.find("a[href=\"#{href}\"]").parent('li').addClass activeCls

