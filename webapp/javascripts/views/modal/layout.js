define([
    'jquery',
    'underscore',
    'marionette',
    'tpl!templates/modal/layout.html'
],function($, _, Marionette, ModalLayoutTpl){
    return Marionette.Layout.extend({
        regions: {
            header: '#modalHeader',
            alert: '#modalAlert',
            body: '#modalBody',
            footer: '#modalFooter'
        },

        template: ModalLayoutTpl,
        templateHelpers: {},

        prop: 'prop',

        initialize: function(opts) {
            this.templateHelpers = _.defaults(opts, this.templateHelpers);
        }
    });
});