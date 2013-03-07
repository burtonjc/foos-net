define([
  'underscore',
  'backbone'
], function(_, Backbone) {
  var Message = Backbone.Model.extend({
      url: '/messages'
  });
  return Message;
});
