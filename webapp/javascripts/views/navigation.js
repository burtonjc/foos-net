define([
    'jquery',
    'marionette',
    'text!templates/navigation.html'
], function($, Marionette, NavigationTpl) {
    return Marionette.ItemView.extend({
        template: NavigationTpl,

        onRender: function() {
            var hash = (window.location.hash || 'home').replace('#', '');
            $(this.el).find('li.' + hash).addClass('active');
            $(FoosNet.navigation.el).delegate('li', 'click', function(a, b, c, d) {
                var activeCls = 'active';
                $(a.currentTarget.parentElement).find('.' + activeCls).removeClass(activeCls);
                $(a.currentTarget).addClass(activeCls);
            });
        }
    });
});