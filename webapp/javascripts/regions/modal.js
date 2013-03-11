define([
    'jquery',
    'underscore',
    'marionette'
], function($, _, Marionette) {
    return Marionette.Region.extend({
        el: "#modal",

        onShow: function(view) {
            $(view.el).find('.modal').modal('show');
        }
    });
});