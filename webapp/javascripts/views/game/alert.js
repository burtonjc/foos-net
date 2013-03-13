define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/game/alert.html'
], function($, _, Marionette, AlertTpl) {
    return Marionette.ItemView.extend({
        template: AlertTpl,
        className: 'alert alert-error fade in',

        initialize: function(opts) {
            this.templateHelpers = {
                message: opts.message
            }
        }
    });
});