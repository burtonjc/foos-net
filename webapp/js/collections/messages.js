define([
  'jquery',
  'underscore',
  'backbone',
  'models/message'
], function($, _, Backbone, MessageModel){
  var Messages = Backbone.Collection.extend({
    model: MessageModel,
    url: '/messages'
  });

  return Messages;
});
