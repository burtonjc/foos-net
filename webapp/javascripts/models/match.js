define([
    'jquery',
    'underscore',
    'backbone'

], function($, _, Backbone) {
    return Backbone.Model.extend({
        urlRoot: '/matches',
        idAttribute: "_id",

        defaults: {
            date: Date.now
        }
    });
});