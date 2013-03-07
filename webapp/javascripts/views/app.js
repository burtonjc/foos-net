define([
    'jquery',
    'underscore',
    'marionette',
    'text!templates/layout.html'


 //  'jquery',
 //  'underscore',
 //  'backbone',
 //  'vm',
	// 'events',
 //  'text!templates/layout.html' 
], function($, _, Marionette, LayoutTmp) {//($, _, Backbone, Vm, Events, layoutTemplate){
    return Marionette.CompositeView.extend({
        template: LayoutTmp
    });


 //  var AppView = Backbone.View.extend({
 //    el: '.container',
 //    initialize: function () {
      
 //    },
 //    render: function () {
	// 		var that = this;
 //      $(this.el).html(layoutTemplate);
 //      Backbone.history.start();
	// 	} 
	// });
 //  return AppView;
});
