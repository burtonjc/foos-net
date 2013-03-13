define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/game/footer.html'
], function($, _, Marionette, GameFooterTpl) {
    return Marionette.ItemView.extend({
        template: GameFooterTpl,

        ui: {
            btnPrimary: '.btn-primary',
            btnCancel: '.btn.cancel'
        },

        triggers: {
            'click .btn-primary': 'next'
        },

        initialize: function() {
            _.bindAll(this);
        },

        deactivate: function() {
            this.ui.btnPrimary.attr('disabled', 'disabled');
        },

        activate: function() {
            this.ui.btnPrimary.removeAttr('disabled');
        }
    });
});