define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/game/header.html'
], function($, _, Marionette, HeaderTpl) {
    return Marionette.ItemView.extend({
        template: HeaderTpl,

        ui: {
            label: '.header-label'
        },

        setLabel: function(label) {
            this.ui.label.html(label);
        }
    });
});