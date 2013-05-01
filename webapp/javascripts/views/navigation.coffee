define [
    'jquery'
    'marionette'
    'text!templates/navigation.html'

], ($, Marionette, NavigationTpl) ->

    Marionette.ItemView.extend
        template: NavigationTpl

        onRender: () ->
            hash = (window.location.hash || 'home').replace '#', ''
            $(@el).find('li.' + hash).addClass 'active'
            $(FoosNet.navigation.el).delegate 'li', 'click', (a, b, c, d) ->
                activeCls = 'active'
                $(a.currentTarget.parentElement).find('.' + activeCls).removeClass activeCls
                $(a.currentTarget).addClass activeCls
