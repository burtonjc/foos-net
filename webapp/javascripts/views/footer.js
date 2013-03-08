define([
    'marionette',
    'text!templates/footer.html'
], function(Marionette, FooterTpl) {
    return Marionette.ItemView.extend({
        template: FooterTpl
    });
});