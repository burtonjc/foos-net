define([
    'jquery',
    'marionette',
    'text!templates/navigation.html'
], function($, Marionette, NavigationTpl) {
    return Marionette.ItemView.extend({
        template: NavigationTpl,

        onRender: function() {
            $(FoosNet.navigation.el).delegate('li', 'click', function(a, b, c, d) {
                var activeCls = 'active';
                $(a.currentTarget.parentElement).find('.' + activeCls).removeClass(activeCls);
                $(a.currentTarget).addClass(activeCls);
            });
        }
    });
});