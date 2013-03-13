define([
    'underscore',
    'jquery',
    'bootstrap',
    'marionette',
    'tpl!templates/home/page.html'
], function(_, $, Bootstrap, Marionette, HomePageTpl) {
    return Marionette.ItemView.extend({
        className: 'home-page',
        template: HomePageTpl,

        events: {
            'click .start-game': 'onStartGameClick'
        },

        onStartGameClick: function() {
            require([
                'foosnet',
                'controllers/game'
            ], function(FoosNet, GameController) {
                new GameController({
                    region: FoosNet.modal
                }).playGame();
            });
        }
    });
});