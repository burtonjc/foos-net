define([
    'jquery',
    'underscore',
    'marionette',
    'text!templates/game/modal.html'
], function($, _, Marionette, GameModalTpl) {
    return Marionette.ItemView.extend({
        template: _.template(GameModalTpl),

        onRender: function() {
            // $(this.el).find('.players-typeahead').typeahead({
            //     source: function(query, callback) {
            //         $.get('/players', {
            //             query: query
            //         }, function(data) {
            //             callback(data);
            //         });
            //     }
            // });
        }
    });
});