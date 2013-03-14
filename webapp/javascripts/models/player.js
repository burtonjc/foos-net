define([
    'jquery',
    'underscore',
    'backbone'
], function($, _, Backbone) {
    return Backbone.Model.extend({
        urlRoot: '/players',
        idAttribute: "_id",

        defaults: {
            elo: 200
        }
    });
});