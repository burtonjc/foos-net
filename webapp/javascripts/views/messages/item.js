define([
    'underscore',
    'marionette',
    'text!templates/messages/item.html'
],function(_, Marionette, MessageItemTpl){
    return Marionette.ItemView.extend({
        template: _.template(MessageItemTpl),
        tagName: 'div',
        className: 'message'
    });
});