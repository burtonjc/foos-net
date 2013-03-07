define([
    'underscore',
    'marionette',
    'views/messages/item',
    'text!templates/messages/template.html'
],function(_, Marionette, MessageItemView, MessageTemplateTpl){
    return Marionette.CompositeView.extend({
        template: _.template(MessageTemplateTpl),
        itemView: MessageItemView,
        tagName: 'div',
        className: 'message'
    });
});