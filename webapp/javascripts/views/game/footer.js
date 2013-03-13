define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/game/footer.html'
], function($, _, Marionette, GameFooterTpl) {
    return Marionette.ItemView.extend({
        template: GameFooterTpl,

        ui: {
            btnNext: '.btn-primary',
            btnCancel: '.btn.cancel'
        },

        triggers: {
            'click .btn-primary': 'next'
        },

        initialize: function() {
            _.bindAll(this);
        },

        deactivate: function() {
            this.ui.btnNext.attr('disabled', 'disabled');
        },

        activate: function() {
            this.ui.btnNext.removeAttr('disabled');
        }
    });
});